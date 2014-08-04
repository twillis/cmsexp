from pyramid.view import view_config
from . import resource
from . import schemas
from . import models as m
import colander
from pyramid.httpexceptions import exception_response, HTTPNotFound


@view_config(route_name="home", 
             renderer="home.html")
def home_view(request):
    return {}


@view_config(route_name="api", 
             context=resource.UserContainer, 
             name="register", 
             renderer="json", 
             request_method="POST")
def register_view(context, request):
    context.register(schemas.RegisterSchema().deserialize(request.POST)["email"])
    return {}


@view_config(route_name="api", 
             context=resource.UserContainer, 
             name="activate", 
             renderer="json", 
             request_method="POST")
def activate_view(context, request):
    data = schemas.ActivateSchema().deserialize(request.POST)
    new_user = context.activate(**data)
    return dict(email=new_user.email, id=new_user.id)



@view_config(route_name="api",
             context=resource.UserContainer,
             name="forgot",
             renderer="json",
             request_method="POST")
def forgot_view(context, request):
    data = schemas.ForgotSchema().deserialize(request.POST)
    context.request_reset(data["email"])
    return {}


@view_config(route_name="api",
             context=resource.UserContainer,
             name="reset",
             renderer="json",
             request_method="POST")
def reset_view(context, request):
    data = schemas.ResetSchema().deserialize(request.POST)
    user = context.do_reset(**data)
    return dict(email=user.email, id=user.id)

@view_config(route_name="api", 
             context=resource.APIRoot, 
             name="login", 
             renderer="json", 
             request_method="POST")
def login_view(context, request):
    context["user"].login(**schemas.LoginSchema().deserialize(request.POST))
    return {}


@view_config(route_name="api", 
             context=resource.APIRoot, 
             name="logout", 
             renderer="json", 
             request_method="POST")
def logout_view(context, request):
    context["user"].logout()
    return {}


@view_config(route_name="api",
             context=resource.UserContainer,
             name="me",
             renderer="json")
def me_view(context, request):
    u = request.authenticated_user()
    if u:
        return dict(email=u.email, first_name=u.first_name, last_name=u.last_name, id=u.id)
    else:
        raise exception_response(403)


@view_config(route_name="api", 
             context=resource.PageContainer,
             renderer="json")
def view_pages(context, request):
    return [dict(title=p.title, slug=p._slug, id=p.id, 
                 author=dict(id=p.author.id, 
                             email=p.author.email)) for p in context.list()]

@view_config(route_name="api",
             context=m.Page,
             renderer="json")
def view_page_show(context, request):
    return dict(title=context.title,
                id=context.id,
                slug=context._slug,
                sections=[dict(id=s.id, 
                               body=s.body, 
                               weight=s.weight) for s in context.sections])


@view_config(route_name="api",
             context=m.Page,
             name="update_section",
             renderer="json",
             request_method="POST")
def view_update_section(context, request):
    section_data = schemas.SectionSchema().deserialize(request.POST)
    section = request.db.query(m.PageSection).get(section_data["id"])

    if not (section or section.page_id == context.id):
        raise HTTPNotFound("no section(%s) for this page" % section_data["id"])
    
    section.apply_data(**section_data)
    return view_page_show(context, request)


@view_config(route_name="api",
             context=m.Page,
             name="create_section",
             renderer="json",
             request_method="POST")
def view_create_section(context, request):
    section_data = schemas.NewSectionSchema().deserialize(request.POST)
    section_data["page_id"] = context.id
    section_data["author_id"] = 1 # fix this
    request.db.add(m.PageSection(**section_data))
    return view_page_show(context, request)



@view_config(context=colander.Invalid, renderer="json")
def validation_error_view(exc, request):
    request.response.status_int = 400
    return exc.asdict()
