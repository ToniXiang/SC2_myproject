"""
Definition of urls for pratice0419_back.
"""
from datetime import datetime
from django.urls import path
from django.contrib import admin
from django.contrib.auth.views import LoginView, LogoutView
from app import forms, views
from app.views import CustomAuthToken,ProductListView,OrderView,register

urlpatterns = [
    path('api/orders/', OrderView.as_view(), name='order-view'),
    path('api/register/', register, name='register'),
    path('api/login/', CustomAuthToken.as_view(), name='api-login'),
    path('api/products/', ProductListView.as_view(), name='product-list'),
    path('', views.home, name='home'),
    path('contact/', views.contact, name='contact'),
    path('about/', views.about, name='about'),
    path('login/',
         LoginView.as_view
         (
             template_name='app/login.html',
             authentication_form=forms.BootstrapAuthenticationForm,
             extra_context=
             {
                 'title': 'Log in',
                 'year' : datetime.now().year,
             }
         ),
         name='login'),
    path('logout/', LogoutView.as_view(next_page='/'), name='logout'),
    path('admin/', admin.site.urls),
]
