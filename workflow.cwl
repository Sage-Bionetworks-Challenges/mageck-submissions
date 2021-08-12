#!/usr/bin/env cwl-runner

# INPUTS:
#   submission_id: Submission ID
#   synapse_config: filepath to .synapseConfig file
#   admin_folder_id: Synapse Folder ID accessible by an admin
#   submitter_folder_id: Synapse Folder ID accessible by the submitter
#   workflow_id: Synapse File ID that links to the workflow archive

cwlVersion: v1.0
class: Workflow

label: MAGeCK workflow integrated with Synapse Evaluation queue
doc: >
  This workflow will utilize the Evaluation queue on Synapse to run MAGeCK
  comparisons.  It will first download the submission (YAML file), extract
  its values, then pass along those values as inputs to the MAGeCK workflow
  (https://github.com/Sage-Bionetworks-Workflows/dockstore-workflow-mageck).

requirements:
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  submissionId: int
  synapseConfig: File
  adminUploadSynId: string
  submitterUploadSynId: string
  workflowSynapseId: string

outputs: {}

steps:
  download_submission:
    run: steps/download_yaml.cwl
    in:
      - id: submission_id
        source: "#submissionId"
      - id: synapse_config
        source: "#synapseConfig"
    out:
      - id: filepath

  get_yaml_inputs:
    run: steps/yaml2json.cwl
    in:
      - id: yaml
        source: "#download_submission/filepath"
    out:
      - id: library_fileview
      - id: output_parent_synapse_id
      - id: comparisons
      
  run_mageck_workflow:
    run: |-
      https://raw.githubusercontent.com/Sage-Bionetworks-Workflows/dockstore-workflow-mageck/master/mageck_synapse_scatter.cwl
    in:
      - id: synapse_config
        source: "#synapseConfig"
      - id: library_fileview
        source: "#get_yaml_inputs/library_fileview"
      - id: output_parent_synapse_id
        source: "#get_yaml_inputs/output_parent_synapse_id"
      - id: comparisons
        source: "#get_yaml_inputs/comparisons" 
    out: []

s:author:
  - class: s:Person
    s:name: Verena Chung
    s:email: verena.chung@sagebase.org
    s:identifier: https://orcid.org/0000-0002-5622-7998

$namespaces:
  s: https://schema.org/