"""
URL configuration for practice0419_backend project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.urls import path
from myapp.views import RegisterView,CustomAuthToken,ProductListView,OrderView,UserView,SendVerificationCodeView,ResetPasswordView,CancelOrderView

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
