import yaml

# Define a Python data structure (e.g. a dictionary)
data = {
    'name': 'John',
    'age': 24,
    'gender': 'Male',
    'country': 'USA'
}

# Serialize the data to YAML format
yaml_data = yaml.dump(data)

# The YAML data is now stored in a string
print(yaml_data)
