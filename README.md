# 📚 Student Database Management System (x86 Assembly)

A DOS-based application for managing student records with file I/O capabilities. Built with x86 assembly language using DOS interrupts.

## 🌟 Features

- 🧑🎓 **Student Management**
  - ➕ Add students (Name, Family, Student Number, Points)
  - 🗑️ Remove students
  - 🔍 Search by name
  - 🧹 Database defragmentation
  - 📋 Show all records

- 💾 **File Operations**
  - 💾 Save database to file (`/database.txt`)
  - 📤 Load database from file

- 📊 **Utilities**
  - 📉 Automatic average calculation
  - 🧮 Input validation
  - 🖥️ Console clearing
  - 🔄 Menu-driven interface

## 🛠️ Requirements

- 🖥️ DOS environment (or DOSBox emulator)
- x86 assembler (MASM/TASM recommended)
- Basic understanding of assembly programming

## 🚀 Quick Start

1. **Assemble the Program**
   ```bash
   tasm /zi STUDENT.ASM
   tlink /v STUDENT
   ```

2. **Run in DOS**
   ```bash
   STUDENT.EXE
   ```

3. **Main Menu**
   ```
   1: Add student
   2: Remove student
   3: Defrag
   4: Search
   5: SHOW DATABASE
   6: Load from file
   7: Save to file
   8: Exit
   ```

## 📖 Detailed Usage

### 📥 Adding Students
1. Select option `1`
2. Enter:
   - Name (max 20 chars)
   - Family name
   - Student number
   - 3 scores (0-20 each)
3. Automatic average calculation

### 🔍 Searching Records
1. Select option `4`
2. Enter search key
3. View matches with highlighted results

### 💾 File Operations
- **Save**: Option `7` → Creates `database.txt`
- **Load**: Option `6` → Loads from `database.txt`

### 🧹 Database Maintenance
- **Defrag**: Option `3` → Removes empty spaces
- **Show All**: Option `5` → Full database printout

## 🧠 Memory Structure

```asm
datasg segment para common 'data'
    stu_db       db 256 dup('0')   ; Main database buffer
    key_db       db 5 dup('0')     ; Search results buffer
    removed_db   db 5 dup('0')     ; Removed entries buffer
    index        dw 0000h          ; Current database index
datasg ends
```

## ⚠️ Important Notes

1. 🔒 **File Path Handling**
   - Hardcoded to `/database.txt`
   - Modify `path` variable for custom locations

2. 📏 **Capacity Limits**
   - Max 256-byte database
   - Max 5 concurrent search results
   - Max 20-character names

3. 🚨 **Error Handling**
   - Empty database warnings
   - Search no-match notifications
   - File I/O error detection

4. 🔄 **Defrag Process**
   - Replaces `0` with `@` markers
   - Compacts valid records
   - Updates database index

## 🛑 Known Limitations

- ❗ DOS-specific interrupts (INT 21h)
- ❗ No native Windows/Mac/Linux support
- ❗ Limited error recovery
- ❗ Fixed buffer sizes

## 📚 Code Structure Highlights

```asm
; Main control flow
main proc far
    ; Initialization
    ; Menu display
    ; User input handling
    ; Function dispatching
main endp

; Key procedures
adst    proc    ; Add student
ser     proc    ; Search
rst     proc    ; Remove student
dfd     proc    ; Defrag
show    proc    ; Display records
lofi    proc    ; Load file
safi    proc    ; Save file
```

## 💡 Pro Tips

1. Use DOSBox for modern systems
2. Monitor register values during debugging
3. Modify buffer sizes for larger databases
4. Implement additional validation as needed
5. Use `DEBUG.EXE` for low-level troubleshooting
