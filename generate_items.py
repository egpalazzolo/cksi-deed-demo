import csv
import os
import yaml

# Paths
csv_file = "_data/cksi-deed-demo.csv"  # Your CSV with objectid,pdf_filename
pdf_folder = "objects/pdfs/"           # Folder where your PDFs live
output_file = "_data/items.yml"        # YAML output

items = []

# Read CSV
with open(csv_file, newline="", encoding="utf-8") as f:
    reader = csv.DictReader(f)
    for row in reader:
        objectid = row["objectid"].strip()
        pdf_filename = row["pdffilename"].strip()

        # Only include if the PDF file actually exists
        if os.path.exists(os.path.join(pdf_folder, pdf_filename)):
            items.append({
                "objectid": objectid,
                "pdffilename": pdffilename
            })
        else:
            print(f"Warning: PDF '{pdffilename}' not found for objectid '{objectid}'")

# Ensure _data folder exists
os.makedirs("_data", exist_ok=True)

# Write YAML
with open(output_file, "w") as f:
    yaml.dump(items, f, sort_keys=False)

print(f"Generated {output_file} with {len(items)} items.")
