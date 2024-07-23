import sys
import os
parent_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(1, parent_dir)
sys.path.insert(1, os.path.join(parent_dir, 'pages'))

from Launch_Your_Server import *
import streamlit as st
import subprocess
from Launch_Your_Server import *
import streamlit_scrollable_textbox as stx
import streamlit_authenticator as stauth
import yaml
from yaml.loader import SafeLoader

cisco_logo = "cisco2.png"

with st.sidebar:
    st.image(cisco_logo, use_column_width=True)

names = ["Dodge Demon", "Jeep Trackhawk", "Cisco User"]
usernames = ["dodge", "jeep", "cisco"]

with open('config.yml') as file:
    config = yaml.load(file, Loader=SafeLoader)
    authenticator = stauth.Authenticate(
    config['credentials'],
    config['cookie']['name'],
    config['cookie']['key'],
    config['cookie']['expiry_days'],
    config['preauthorized'], 
)

if st.session_state["authentication_status"]:
    cols = st.columns(8)
    with cols[7]:
        authenticator.logout("Logout")
    st.title(f'Welcome *{st.session_state["name"]}*')
elif st.session_state["authentication_status"] is False:
    st.error('Username/password is incorrect')
elif st.session_state["authentication_status"] is None:
    st.warning('Please enter your username and password')

# If this is used then make sure to update config file
def reset_password():
    if st.session_state["authentication_status"]:
        try:
            if authenticator.reset_password(st.session_state["username"]):
                st.success('Password modified successfully')
        except Exception as e:
            st.error(e)
    update_config_file()

# If this is used then make sure to update config file
def register_user():
    try:
        email_of_registered_user, username_of_registered_user, name_of_registered_user = authenticator.register_user(pre_authorization=False)
        if email_of_registered_user:
            st.success('User registered successfully')
    except Exception as e:
        st.error(e)
    update_config_file()

# If this is used then make sure to update config file
def reset_password():
    try:
        username_of_forgotten_password, email_of_forgotten_password, new_random_password = authenticator.forgot_password()
        if username_of_forgotten_password:
            st.success('New password to be sent securely')
            # The developer should securely transfer the new password to the user.
        elif username_of_forgotten_password == False:
            st.error('Username not found')
    except Exception as e:
        st.error(e)
    update_config_file()

# If this is used then make sure to update config file
def reset_username():
    try:
        username_of_forgotten_username, email_of_forgotten_username = authenticator.forgot_username()
        if username_of_forgotten_username:
            st.success('Username to be sent securely')
            # The developer should securely transfer the username to the user.
        elif username_of_forgotten_username == False:
            st.error('Email not found')
    except Exception as e:
        st.error(e)
    update_config_file()

# Update config file after this
def update_user():
    if st.session_state["authentication_status"]:
        try:
            if authenticator.update_user_details(st.session_state["username"]):
                st.success('Entries updated successfully')
        except Exception as e:
            st.error(e)
    update_config_file()


def update_config_file():
    with open('../config.yaml', 'w') as file:
        yaml.dump(config, file, default_flow_style=False)


authenticator.login()


# cols = st.columns(3)
# with cols[0]:
#     if authenticator.reset_password(st.session_state["username"]):
#         reset_password()
# with cols[1]:
#     if st.button("Forgot Username"):
#         reset_username()
# with cols[2]:
#     if st.button("Register New Account"):
#         register_user()
