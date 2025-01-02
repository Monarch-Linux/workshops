from jinja2 import Environment, FileSystemLoader
import os

templates_dir = "templates"

env = Environment(loader=FileSystemLoader(templates_dir))

documents = [
    item
    for item in os.listdir(templates_dir)
    if os.path.isdir(os.path.join(templates_dir, item))
]

os.makedirs("out", exist_ok=True)

for document in documents:
    path = f"{document}/index.md.jinja"
    output_name = f"{document}.md"

    template = env.get_template(path)
    output = template.render()

    with open(f"out/{output_name}", "w") as file:
        file.write(output)
