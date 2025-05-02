"""
Definition of urls for pratice0419_back.
"""

from django.urls import path
from django.contrib import admin
from app import views
from app.views import CustomAuthToken,ProductListView,OrderView,register

urlpatterns = [
    path('api/orders/', OrderView.as_view(), name='order-view'),
    path('api/register/', register, name='register'),
    path('api/login/', CustomAuthToken.as_view(), name='api-login'),
    path('api/products/', ProductListView.as_view(), name='product-list'),
    path('', views.home, name='home'),
    path('contact/', views.contact, name='contact'),
    path('about/', views.about, name='about'),
    path('admin/', admin.site.urls),
]
