import os

def delete_files(file_list: list[str]):
    for file_path in file_list:
        if os.path.exists(file_path):
            os.remove(file_path)
            print(f"${file_path} deleted successfully.")
        else:
            print("File does not exist.")
