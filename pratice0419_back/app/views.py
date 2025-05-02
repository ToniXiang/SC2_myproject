"""
Definition of views.
"""

from datetime import datetime
from django.shortcuts import render
from django.http import HttpRequest
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework import status
from .models import Product,Order
from .serializers import ProductSerializer,OrderSerializer,CreateOrderSerializer,CustomAuthTokenSerializer
from rest_framework.views import APIView
from django.contrib.auth.models import User 
from rest_framework.authtoken.views import ObtainAuthToken
from rest_framework.authtoken.models import Token
from rest_framework.response import Response
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated

@api_view(['POST'])
@permission_classes([AllowAny])
def register(request):
    """
    註冊 API：存儲用戶的姓名、密碼和電子郵件。
    """
    username = request.data.get('username')
    email = request.data.get('email')
    password = request.data.get('password')

    if not username or not email or not password:
        return Response({'error': '需要完整郵件、名稱與密碼'}, status=status.HTTP_400_BAD_REQUEST, content_type='application/json; charset=utf-8')

    if User.objects.filter(email=email).exists():
        return Response({'error': '此郵件已被註冊'}, status=status.HTTP_400_BAD_REQUEST, content_type='application/json; charset=utf-8')

    user = User.objects.create_user(username=username, email=email, password=password)
    return Response({'message': '註冊成功',
    },status=status.HTTP_201_CREATED, content_type='application/json; charset=utf-8')
class CustomAuthToken(ObtainAuthToken):
    """
    登入 API：使用電子郵件和密碼進行驗證。
    """
    def post(self, request):
        serializer = CustomAuthTokenSerializer(data=request.data, context={'request': request})
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']
        token, created = Token.objects.get_or_create(user=user)
        return Response({
            'token': token.key,
            'username': user.username,
        },status=status.HTTP_200_OK, content_type='application/json; charset=utf-8')
@permission_classes([AllowAny])
class ProductListView(APIView):
    """
    商品 API：獲取商品列表。
    """
    def get(self, request):
        try:
            products = Product.objects.all()
            serializer = ProductSerializer(products, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'error':'資料錯誤'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR, content_type='application/json; charset=utf-8')
class OrderView(APIView):
    """
    訂單 API：傳出訂單列表、傳入訂單。
    """
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]
    def get(self, request):
        """
        傳出訂單列表：僅返回當前使用者的訂單。
        """
        try:
            orders = Order.objects.filter(user=request.user)
            serializer = OrderSerializer(orders, many=True)
            #print(serializer.data);
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'error':'伺服器錯誤'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR, content_type='application/json; charset=utf-8')
    def post(self, request):
        """
        傳入訂單：創建屬於當前使用者的訂單。
        """
        #print(f"Authenticated User: {request.user}")
        #print(f"Request Data: {request.data}") 
        serializer = CreateOrderSerializer(data=request.data, context={'request': request})
        try:
            if serializer.is_valid():
                order = serializer.save(user=request.user)
                return Response(OrderSerializer(order).data, status=status.HTTP_201_CREATED)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except Exception as e:
            return Response({'error':'伺服器錯誤'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR, content_type='application/json; charset=utf-8')
        
def home(request):
    """Renders the home page."""
    assert isinstance(request, HttpRequest)
    return render(
        request,
        'app/index.html',
        {
            'title':'Home Page',
            'year':datetime.now().year,
        }
    )

def contact(request):
    """Renders the contact page."""
    assert isinstance(request, HttpRequest)
    return render(
        request,
        'app/contact.html',
        {
            'title':'Contact',
            'message':'Your contact page.',
            'year':datetime.now().year,
        }
    )

def about(request):
    """Renders the about page."""
    assert isinstance(request, HttpRequest)
    return render(
        request,
        'app/about.html',
        {
            'title':'About',
            'message':'Your application description page.',
            'year':datetime.now().year,
        }
    )
