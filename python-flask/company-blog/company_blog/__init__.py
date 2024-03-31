from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager

app = Flask(__name__)

app.config['SECRET_KEY'] = 'mysecret'

# Database Setup
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:root@localhost:5432/company_blog'
app.config['SQLALCHEMY_TRACH_MODIFICATIONS'] = False
db = SQLAlchemy(app)

# Login Config
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'users.login'


from company_blog.core.views import core
from company_blog.users.views import users
from company_blog.error_pages.handlers import error_pages

app.register_blueprint(core)
app.register_blueprint(users)
app.register_blueprint(error_pages)
