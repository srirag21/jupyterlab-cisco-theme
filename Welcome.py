import streamlit as st
import subprocess
from pages import Launch_Your_Server

# from st_pages import Page, show_pages, add_page_title

# add_page_title()


# show_pages(
#     [
#         Page("Welcome.py", "Hello", "🏠"),
#         Page("pages/Launch_Your_Server.py", "Launch Your Server", ":books:"),
#     ]
# )

# Load Cisco logo image
cisco_logo = "cisco2.png"

# Initialize the sidebar with the Cisco logo at the top
with st.sidebar:
    st.image(cisco_logo, use_column_width=True)
name = st.text_input('What is your name?')
st.write("Welcome ", name)
