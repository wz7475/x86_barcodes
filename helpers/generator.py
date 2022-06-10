with open("new_codes.txt") as f:
    data = f.readlines()

ouptut = []
for data_string in data:
    ouptut.append("\t" + data_string.strip() + ",\n")

with open("codes_table.txt", "w") as f:
    f.writelines(ouptut)