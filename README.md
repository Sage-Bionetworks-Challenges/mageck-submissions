# MAGeCK Comparisons via Synapse

This workflow will utilize the Evaluation queue on Synapse to run [MAGeCK comparisons](https://github.com/Sage-Bionetworks-Workflows/dockstore-workflow-mageck) between the inputs as specified in the submission file (a YAML file).

### Usage
To use this workflow as part of a Synapse Evaluation queue, first copy the link address to the zipped archive of this repository:

```
https://github.com/Sage-Bionetworks-Workflows/dockstore-workflow-mageck
```

Then, go to [Synapse](https://www.synapse.org/) and create a new File Link in the respective Synaspe Project.  Paste the link above under **URL**, and name it whatever you like, e.g. `workflow`.

Once the File Link has been created, add a new annotation called `ROOT_TEMPLATE` and give it the value of `mageck-submissions-main/workflow.cwl`.  This annotation will notify the [Synapse Workflow Orchestrator](https://github.com/Sage-Bionetworks/SynapseWorkflowOrchestrator) as to which file within the archive is the workflow script to run.

Finally, copy the Synapse ID of this File Link as it will be needed to configure the [Synapse Workflow Orchestrator](https://github.com/Sage-Bionetworks/SynapseWorkflowOrchestrator) on the instance.

### Running locally
You can test the workflow on your local machine with the following command:

```bash
cwl-runner workflow.cwl inputs.yaml
```

where `inputs.yaml` is a YAML file with 5 values:

* submission_id - Submission ID
* synapse_config - filepath to .synapseConfig file
* admin_folder_id - Synapse Folder ID accessible by an admin
* submitter_folder_id - Synapse Folder ID accessible by the submitter
* workflow_id - Synapse ID that links to the workflow archive

For example:

```yaml
submission_id: 1234567
synapse_config:
  class: File
  path: /Users/awesome-user/.synapseConfig
admin_folder_id: syn123
submitter_folder_id: syn345
workflow_id: syn678
```

Alternatively, all inputs can be passed from the command-line, e.g.

```bash
cwl-runner workflow.cwl \
  --submission_id 1234567 \
  --synapse_config /Users/awesome-user/.synapseConfig \
  --admin_folder_id syn123 \
  --submitter_folder_id syn456 \
  --workflow_id: syn678
```