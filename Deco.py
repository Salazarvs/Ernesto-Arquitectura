import tkinter as tk
from tkinter import filedialog, messagebox

def convert_to_binary(instruction):
    opcodes = {
        "ADD": "100000",
        "SUBSTRACT": "100010",
        "AND": "100100",
        "OR": "100101",
        "SET ON LESS THAN": "101010",
        "FULL4": "000000_00000_00000_00000_00000_000000\n000000_00000_00000_00000_00000_000000\n000000_00000_00000_00000_00000_000000\n000000_00000_00000_00000_00000_000000",
        "FULL3": "000000_00000_00000_00000_00000_000000\n000000_00000_00000_00000_00000_000000\n000000_00000_00000_00000_00000_000000"
    }

    parts = instruction.split()

    if len(parts) == 1 and parts[0].upper() in opcodes:
        return opcodes[parts[0].upper()]

    if len(parts) != 4:
        return "Instrucción no válida"

    operation = parts[0].upper()
    reg4 = int(parts[1][1:])
    reg2 = int(parts[2][1:])
    reg3 = int(parts[3][1:])

    reg4_bin = format(reg4, '05b')
    reg2_bin = format(reg2, '05b')
    reg3_bin = format(reg3, '05b')

    if operation in opcodes:
        operation_bin = opcodes[operation]
    else:
        return "Operación no válida"

    section1 = '000000'
    section5 = '00000'

    instruction_bin = f"{section1}_{reg2_bin}_{reg3_bin}_{reg4_bin}_{section5}_{operation_bin}"

    return instruction_bin

def DisplayWindow():
    ventana = tk.Tk()
    ventana.title("Decoder.Py")
    ventana.geometry("800x700")
    ventana.resizable(False, False)
    ventana.config(bg="#4B0082")

    titleLabel = tk.Label(ventana, text="Decoder.Py", font=("Arial", 24, "bold"), fg="#E6E6FA", bg="#4B0082")
    titleLabel.pack(pady=10)

    instruction_label = tk.Label(ventana, text="Instrucciones:", font=("Arial", 16), fg="#E6E6FA", bg="#4B0082")
    instruction_label.pack(pady=5)

    text_area = tk.Text(ventana, wrap='word', height=10, width=60, padx=5, pady=5, bd=2, relief="groove", font=("Arial", 10), bg="#9370DB", fg="#FFFFFF")
    text_area.pack(pady=5, padx=10)

    result_label = tk.Label(ventana, text="Instrucción convertida:", font=("Arial", 16), fg="#E6E6FA", bg="#4B0082")
    result_label.pack(pady=5)

    result_text = tk.Text(ventana, wrap='word', height=15, width=60, font=("Arial", 10), bd=2, relief="groove", bg="#BA55D3", fg="#FFFFFF")
    result_text.pack(pady=5, padx=10)

    def on_convert():
        raw_instructions = text_area.get(1.0, tk.END).strip().splitlines()
        transformed = []

        for instruction in raw_instructions:
            instruction = instruction.strip()
            binary_instruction = convert_to_binary(instruction)
            transformed.append(binary_instruction)

        result_text.delete(1.0, tk.END)
        result_text.insert(tk.END, "\n".join(transformed))

    def open_file():
        file_path = filedialog.askopenfilename(filetypes=[("Text files", "*.txt")])
        if file_path:
            with open(file_path, 'r') as file:
                content = file.read()
                text_area.delete(1.0, tk.END)
                text_area.insert(tk.END, content)

    def save_file():
        file_path = filedialog.asksaveasfilename(defaultextension=".txt", filetypes=[("Text files", "*.txt")])
        if file_path:
            with open(file_path, 'w') as file:
                content = result_text.get(1.0, tk.END).strip()
                file.write(content)
            messagebox.showinfo("Guardar archivo", "Archivo guardado exitosamente")

    button_frame = tk.Frame(ventana, bg="#4B0082")
    button_frame.pack(pady=10)

    convert_button = tk.Button(button_frame, text="Convert", command=on_convert, width=10, font=("Arial", 10), bg="#8A2BE2", fg="white", relief="raised")
    convert_button.grid(row=0, column=0, padx=5)

    open_button = tk.Button(button_frame, text="Open File", command=open_file, width=10, font=("Arial", 10), bg="#9370DB", fg="white", relief="raised")
    open_button.grid(row=0, column=1, padx=5)

    save_button = tk.Button(button_frame, text="Save File", command=save_file, width=10, font=("Arial", 10), bg="#BA55D3", fg="white", relief="raised")
    save_button.grid(row=0, column=2, padx=5)

    button_exit = tk.Button(button_frame, text="Exit", command=ventana.quit, width=10, font=("Arial", 10), bg="#DDA0DD", fg="white", relief="raised")
    button_exit.grid(row=0, column=3, padx=5)

    ventana.mainloop()

if __name__ == "__main__":
    DisplayWindow()
