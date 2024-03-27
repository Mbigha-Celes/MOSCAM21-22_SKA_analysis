# Snakemake workflow: `SKA-analysis`

[![Snakemake](https://img.shields.io/badge/snakemake-≥6.3.0-brightgreen.svg)](https://snakemake.github.io)


A Snakemake workflow for the analysis of NGS reads with SKA (Harris, 2018) to identify the (mosquito) species of different samples.


## Usage
### Quick usage

1. Make sure to have a tab-separated file that contains your sample name in the first column (`sample`), trimmed forward read paths in the second column (`fq1`) and the trimmed reverse read paths in the third (`fq2`). For an example see the `samples.tsv` file.

2. In `config/config.yaml` provide the right path to the genome you want to map your reads to, the tab-separated file with the info on your samples (see above) and the number of threads you want to use.

3. Make sure you have [snakemake](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html#full-installation) installed. Run the `snakemake` pipeline from the top folder of this repo with:

```bash
snakemake
```

4. The final output is a `ska.distances.tsv` file, which can be used for a cluster analysis to determine the samples' species.

### Advanced Usage (SLURM)
In `slurm-profile/config.yaml` you can change specific slurm job settings.

Run following command from a `tmux` window :

```bash
snakemake --profile slurm-profile/
```

Snakemake will handle the submitting of jobs and the output removal of failed jobs.

