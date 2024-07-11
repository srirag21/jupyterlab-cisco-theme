from streamlit_authenticator.utilities.hasher import Hasher
import pickle
from pathlib import Path

names = ["Dodge Demon", "Jeep Trackhawk"]
usernames = ["dodge", "jeep"]
passwords = ["abc", "def"]
hashed_passwords = Hasher(passwords).generate()
file_path = Path(__file__).parent / "hashed_pw.pkl"

with file_path.open("wb") as file:
    pickle.dump(hashed_passwords, file)