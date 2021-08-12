# MAGeCK Comparisons via Synapse

This workflow will utilize the Evaluation queue on Synapse to run [MAGeCK comparisons](https://github.com/Sage-Bionetworks-Workflows/dockstore-workflow-mageck) between the inputs as specified in the submission file (a YAML file).

### Usage
To use this workflow as part of a Synapse Evaluation queue, first copy the link address to the zipped archive of this repository:

```
https://github.com/Sage-Bionetworks-Challenges/mageck-submissions/archive/refs/heads/main.zip
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

* submissionId - Submission ID
* synapseConfig - filepath to .synapseConfig file
* adminUploadSynId - Synapse Folder ID accessible by an admin
* submitterUploadSynId - Synapse Folder ID accessible by the submitter
* workflowSynapseId - Synapse ID that links to the workflow archive

For example:

```yaml
submissionId: 1234567
synapseConfig:
  class: File
  path: /Users/awesome-user/.synapseConfig
adminUploadSynId: syn123
submitterUploadSynId: syn345
workflowSynapseId: syn678
```

Alternatively, all inputs can be passed from the command-line, e.g.

```bash
cwl-runner workflow.cwl \
  --submissionId 1234567 \
  --synapseConfig /Users/awesome-user/.synapseConfig \
  --adminUploadSynId syn123 \
  --submitterUploadSynId syn456 \
  --workflowSynapseId: syn678
```