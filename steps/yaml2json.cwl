#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

label: Reformat a YAML file to JSON

requirements:
  - class: InlineJavascriptRequirement

inputs:
  yaml: File

outputs:
  - id: results
    type: File
    outputBinding:
      glob: results.json

  - id: library_fileview
    type: string
    outputBinding:
      glob: results.json
      loadContents: true
      outputEval: $(JSON.parse(self[0].contents)['library_fileview'])

  - id: output_parent_synapse_id
    type: string
    outputBinding:
      glob: results.json
      loadContents: true
      outputEval: $(JSON.parse(self[0].contents)['output_parent_synapse_id'])

  - id: comparison_name
    type: string
    outputBinding:
      glob: results.json
      loadContents: true
      outputEval: $(JSON.parse(self[0].contents)['comparison_name'])

  - id: library_name
    type: string
    outputBinding:
      glob: results.json
      loadContents: true
      outputEval: $(JSON.parse(self[0].contents)['library_name'])

  - id: treatment_synapse_ids
    type: string[]
    outputBinding:
      glob: results.json
      loadContents: true
      outputEval: $(JSON.parse(self[0].contents)['treatment_synapse_ids'])

  - id: control_synapse_ids
    type: string[]
    outputBinding:
      glob: results.json
      loadContents: true
      outputEval: $(JSON.parse(self[0].contents)['control_synapse_ids'])

baseCommand: yaml2json.py
arguments:
  - valueFrom: $(inputs.yaml.path)
    prefix: -y

hints:
  DockerRequirement:
    dockerPull: docker.synapse.org/syn25981862/yaml2json:v1

s:author:
  - class: s:Person
    s:name: Verena Chung
    s:email: verena.chung@sagebase.org
    s:identifier: https://orcid.org/0000-0002-5622-7998

$namespaces:
  s: https://schema.org/