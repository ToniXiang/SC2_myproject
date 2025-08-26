"""
Definition of urls for practice0419_backend.
"""
from django.urls import path
from app.views import RegisterView,CustomAuthToken,ProductListView,OrderView,UserView,SendVerificationCodeView,ResetPasswordView,CancelOrderView

urlpatterns = [
    path('api/orders/', OrderView.as_view(), name='orders'),
    path('api/user/info', UserView.as_view(), name='user_info'),
    path('api/register/', RegisterView.as_view(), name='register'),
    path('api/login/', CustomAuthToken.as_view(), name='login'),
    path('api/products/', ProductListView.as_view(), name='products'),
    path('api/send_verification_code/',SendVerificationCodeView.as_view(),name='send_verification_code'),
    path('api/reset_password/',ResetPasswordView.as_view(),name='reset_password'),
    path('api/orders/<int:order_id>/cancel/', CancelOrderView.as_view(), name='orders_cancel'),
]
