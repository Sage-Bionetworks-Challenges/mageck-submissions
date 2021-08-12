#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

label: Download a Synapse Evaluation submission

requirements:
  - class: InlineJavascriptRequirement

inputs:
  submission_id: int
  synapse_config: File

outputs:
  - id: filepath
    type: File?
    outputBinding:
      glob: $("submission-" + inputs.submission_id)

baseCommand: challengeutils
arguments:
  - valueFrom: $(inputs.synapse_config.path)
    prefix: -c
  - valueFrom: download-submission
  - valueFrom: $(inputs.submission_id)
  - valueFrom: results.json
    prefix: --output

hints:
  DockerRequirement:
    dockerPull: sagebionetworks/challengeutils:v4.0.1

s:author:
  - class: s:Person
    s:name: Verena Chung
    s:email: verena.chung@sagebase.org
    s:identifier: https://orcid.org/0000-0002-5622-7998

$namespaces:
  s: https://schema.org/