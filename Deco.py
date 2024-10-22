import tkinter as tk
from tkinter import filedialog
from tkinter import messagebox

def DisplayWindow():
    ventana = tk.Tk()
    ventana.title("Txt Modder for Ernesto")
    ventana.geometry("800x700")
    ventana.resizable(True, True)

    titleLabel = tk.Label(ventana, text="Ernesto's Txt Modder", font=("Arial", 40, "bold"), fg="#333")
    titleLabel.pack(pady=10)

    button_frame = tk.Frame(ventana)
    button_frame.pack(pady=10)  

    button_explore = tk.Button(button_frame, text="Explore File", command=selectFile, width=15, font=("Arial", 12), bg="#4E3B31", fg="white")
    button_explore.grid(row=2, column=0, padx=10, pady=5)

    button_save = tk.Button(button_frame, text="Save File", command=saveFile, width=15, font=("Arial", 12), bg="#7B5B4D", fg="white")
    button_save.grid(row=2, column=1, padx=10, pady=5)

    button_transform = tk.Button(button_frame, text="Instructions to Binary", command=transformInstructions, width=20, font=("Arial", 12), bg="#A27C66", fg="white")
    button_transform.grid(row=2, column=2, padx=10, pady=5)

    button_exit = tk.Button(button_frame, text="Leave", command=ventana.quit, width=15, font=("Arial", 12), bg="#A50000", fg="white")
    button_exit.grid(row=2, column=3, padx=10, pady=5)

    global text_area
    text_area = tk.Text(ventana, wrap='word', height=20, width=70, padx=10, pady=10, bd=2, relief="groove", font=("Arial", 12))
    text_area.pack(pady=10)

    ventana.mainloop()

def selectFile():
    file_path = filedialog.askopenfilename(filetypes=[("Text Files", "*.txt")], title="Select a TXT file")
    if file_path:
        try:
            with open(file_path, 'r', encoding='utf-8') as file:
                content = file.read()
                text_area.delete(1.0, tk.END)  
                text_area.insert(tk.END, content) 
            messagebox.showinfo("File Selected", f"File loaded: {file_path}")
        except Exception as e:
            messagebox.showerror("Error", f"An error occurred: {str(e)}")
    else:
        messagebox.showwarning("No file selected", "Please select a TXT file.")

def saveFile():
    file_path = filedialog.asksaveasfilename(defaultextension=".txt", filetypes=[("Text Files", "*.txt")], title="Save As")
    if file_path:
        try:
            content = text_area.get(1.0, tk.END) 
            with open(file_path, 'w', encoding='utf-8') as file:
                file.write(content)
            messagebox.showinfo("File Saved", f"File saved at: {file_path}")
        except Exception as e:
            messagebox.showerror("Error", f"An error occurred: {str(e)}")
    else:
        messagebox.showwarning("No file selected", "Please select a location to save the file.")

def transformInstructions():
    raw_instructions = text_area.get(1.0, tk.END).strip().splitlines()
    transformed = []

    for instruction in raw_instructions:
        instruction = instruction.strip()
        
        if instruction.startswith('WE'):
            we_bit = instruction.split()[1]
            we_bin = '01' if we_bit == '1' else '00'  # Convert WE to 2 bits
        elif instruction.startswith('DirLec1'):
            dirlec1 = instruction.split('$')[1]
            dirlec1_bin = format(int(dirlec1), '05b')  # 5 bits
        elif instruction.lower() == 'suma':
            opcode_bin = '010'  # Suma opcode (3 bits)
        elif instruction.lower() == 'and':
            opcode_bin = '000'  # AND opcode (3 bits)
        elif instruction.lower() == 'or':
            opcode_bin = '001'  # OR opcode (3 bits)
        elif instruction.lower() == 'resta':
            opcode_bin = '110'  # Resta opcode (3 bits)
        elif instruction.lower() == 'menor que':
            opcode_bin = '111'  # Menor que opcode (3 bits)
        elif instruction.lower() == 'nor':
            opcode_bin = '100'  # NOR opcode (3 bits)
        elif instruction.startswith('DirLec2'):
            dirlec2 = instruction.split('$')[1]
            dirlec2_bin = format(int(dirlec2), '05b')  # 5 bits
        elif instruction.startswith('Dir'):
            dir = instruction.split('$')[1]
            dir_bin = format(int(dir), '05b')  # 5 bits

    if all(v is not None for v in [we_bin, dirlec1_bin, opcode_bin, dirlec2_bin, dir_bin]):
        # Concatenate the bits to form a 20-bit binary instruction
        instruction_bin = f"{we_bin}{dirlec1_bin}{opcode_bin}{dirlec2_bin}{dir_bin}"
        transformed.append(instruction_bin)

    result = '\n'.join(transformed)
    text_area.delete(1.0, tk.END)
    text_area.insert(tk.END, result)

if __name__ == "__main__":
    DisplayWindow()