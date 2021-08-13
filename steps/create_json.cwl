#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

label: Creates a JSON file out of a label and value

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: create_json.py
        entry: |
          #!/usr/bin/env python
          import argparse
          import json

          parser = argparse.ArgumentParser()
          parser.add_argument("-k", "--key")
          parser.add_argument("-v", "--value")
          args = parser.parse_args()

          with open("results.json", 'w') as json_file:
            json_file.write(json.dumps({args.key: args.value}))

inputs:
  key: string
  value: string

outputs:
  - id: json
    type: File
    outputBinding:
      glob: $("results.json")

baseCommand: python
arguments:
  - valueFrom: create_json.py
  - valueFrom: $(inputs.key)
    prefix: -k
  - valueFrom: $(inputs.value)
    prefix: -v

s:author:
  - class: s:Person
    s:name: Verena Chung
    s:email: verena.chung@sagebase.org
    s:identifier: https://orcid.org/0000-0002-5622-7998

$namespaces:
  s: https://schema.org/