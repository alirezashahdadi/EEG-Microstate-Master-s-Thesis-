# EEG Microstate Analysis in MCI and Healthy Controls

This repository contains MATLAB scripts developed and used during my master's thesis, which focused on resting-state EEG microstate analysis in individuals with Mild Cognitive Impairment (MCI) and healthy controls.

The main goal of the study was to investigate differences in the temporal characteristics and transition patterns of EEG microstates between the two groups, with particular attention to frequency-specific changes.

## Study Overview

The study included resting-state EEG recordings from 66 participants (33 MCI patients and 33 healthy controls). Each recording consisted of approximately 8 minutes of eyes-closed resting-state EEG.

EEG preprocessing involved the PREP pipeline, CleanLine, and ICA-based artifact removal using ICLabel. Microstate analysis was performed using GFP peaks and k-means clustering to identify four conventional microstate classes (A–D).

In addition to broadband EEG, the analysis focused on the alpha and beta frequency bands to examine whether microstate characteristics differed across frequencies.

The investigated parameters included:

* Mean microstate duration
* Microstate occurrence and coverage
* Transition probabilities between microstate classes
* Non-repeating microstate ratios
* Frequency-dependent differences in microstate parameters

Statistical analyses were used to compare the MCI and healthy control groups, including permutation testing, bootstrap confidence intervals, effect size estimation, and correction for multiple comparisons.

## MATLAB Scripts

The repository includes scripts for different parts of the analysis.

| File                            | Description                                     |
| ------------------------------- | ----------------------------------------------- |
| `MicrostateAnalysis.m`          | EEG microstate analysis                         |
| `FDR.m`                         | False Discovery Rate correction                 |
| `bootstrap_CI.m`                | Bootstrap-based confidence interval estimation  |
| `permutation_Test_4class.m`     | Permutation testing for four microstate classes |
| `EffectSize_Cohen'd.m`          | Effect size calculation using Cohen's d         |
| `transition_plot.m`             | Visualization of microstate transitions         |
| `Plot_Microstates_parameters.m` | Visualization of microstate parameters          |
| `Histogram_RWT.m`               | Histogram plotting                              |
| `Nonrepeatingratio.m`           | Analysis of non-repeating microstate patterns   |

## Tools

The analysis was mainly carried out in MATLAB, using EEGLAB and MicrostateLab for EEG processing and microstate analysis.

## Notes

These scripts were written for the specific analysis performed in my thesis. Some parts may need adjustments depending on the dataset, variable names, or MATLAB environment.

The repository is intended to document the analysis methods and statistical procedures used in the project. Raw EEG recordings are not included.

## Research Interests

EEG Signal Processing | EEG Microstates | Computational Neuroscience | Brain Dynamics | Neurodegenerative Disorders
