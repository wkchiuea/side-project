from flask import Blueprint, render_template
error_pages = Blueprint('error_pages', __name__)


@error_pages.app_errorhandler(404)
def page_not_found(error):
    return render_template('error_pages/404.html'), 404


@error_pages.app_errorhandler(403)
def forbidden(error):
    return render_template('error_pages/403.html'), 403