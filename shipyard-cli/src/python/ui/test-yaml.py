import yaml

# Open the YAML file
with open('data.yaml', 'r') as f:
    # Load the YAML data from the file
    data = yaml.safe_load(f)
    
# The data is now stored in a Python data structure (e.g. a dictionary)
print(data)
