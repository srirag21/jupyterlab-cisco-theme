import subprocess
import streamlit as st
import time
import threading

cisco_logo = "cisco2.png"

# Initialize the sidebar with the Cisco logo at the top
with st.sidebar:
    st.image(cisco_logo, use_column_width=True)

def read_output(process, output):
    for line in iter(process.stdout.readline, b''):
        output.append(line)
@st.cache
def launch():
        process = subprocess.Popen('./run_docker.sh', shell=True, executable="/bin/bash", stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, bufsize=1, universal_newlines=True)

        # Initialize a list in session state to store the output
        if 'output' not in st.session_state:
                st.session_state.output = []

        # Start a thread to read the output
        thread = threading.Thread(target=read_output, args=(process, st.session_state.output))
        thread.start()

        # Display the output as it is being collected
        for line in st.session_state.output:
                st.text(line)


st.title("Launch your own pre-configured server!")

col1, col2, col3 = st.columns([4,6,1])

with col1:
        st.write("")

with col2:
        st.button("Launch Server", on_click=launch())

with col3:
        st.write("")   