import subprocess
import streamlit as st
import time

cisco_logo = "cisco2.png"

with st.sidebar:
    st.image(cisco_logo, use_column_width=True)

def read_output(process, output):
    for line in iter(process.stdout.readline, b''):
        output.append(line)
# @st.cache_resource
def launch():
        with st.spinner('Starting the server...'):
                process = subprocess.Popen(
                './run_docker.sh',
                shell=True, 
                executable="/bin/bash", 
                stdout=subprocess.PIPE, 
                stderr=subprocess.PIPE, 
                text=True, 
                bufsize=1
                )
                
                progress_bar = st.progress(0)
                
                output = []
                
                while True:
                        line = process.stdout.readline()
                        if line:
                                output.append(line)
                                percent_complete = calculate_progress(output)
                                progress_bar.progress(percent_complete)
                        elif process.poll() is not None:
                                break 
                        
                if process.returncode == 0:
                        progress_bar.progress(100) 
                        st.success('Server started successfully!')
                        st.link_button("Click Here", "http://127.0.0.1:8887")
                else:
                        stderr = process.stderr.read()
                        st.error('Server failed to start')
                        st.text_area("Error Output", stderr, key="safdf")

def calculate_progress(output):
    return min(100, len(output) * 5) 


st.title("Launch your own pre-configured server!")

if st.button("Launch Server"):
        launch()
    