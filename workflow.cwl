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
  - class: InlineJavascriptRequirement
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
      - id: treatment_synapse_ids
      - id: control_synapse_ids
      - id: library_name
      - id: comparison_name
      
  run_mageck_workflow:
    run: |-
      https://raw.githubusercontent.com/Sage-Bionetworks-Workflows/dockstore-workflow-mageck/master/subworkflows/mageck_synapse.cwl
    in:
      - id: synapse_config
        source: "#synapseConfig"
      - id: library_fileview
        source: "#get_yaml_inputs/library_fileview"
      - id: output_parent_synapse_id
        source: "#get_yaml_inputs/output_parent_synapse_id"
      - id: treatment_synapse_ids
        source: "#get_yaml_inputs/treatment_synapse_ids" 
      - id: control_synapse_ids
        source: "#get_yaml_inputs/control_synapse_ids" 
      - id: library_name
        source: "#get_yaml_inputs/library_name" 
      - id: comparison_name
        source: "#get_yaml_inputs/comparison_name" 
    out:
      - id: output_folder_id

  create_annotations:
    run: steps/create_json.cwl
    in:
      - id: key
        default: "output_folder"
      - id: value
        source: "#run_mageck_workflow/output_folder_id"
    out:
      - id: json

  annotate_submission:
    run: |-
      https://raw.githubusercontent.com/Sage-Bionetworks/ChallengeWorkflowTemplates/v3.1/cwl/annotate_submission.cwl
    in:
      - id: submissionid
        source: "#submissionId"
      - id: annotation_values
        source: "#create_annotations/json"
      - id: to_public
        default: true
      - id: force
        default: true
      - id: synapse_config
        source: "#synapseConfig"
    out: [finished]

s:author:
  - class: s:Person
    s:name: Verena Chung
    s:email: verena.chung@sagebase.org
    s:identifier: https://orcid.org/0000-0002-5622-7998

$namespaces:
  s: https://schema.org/