# ASA
Absolute Stress Analysis from HR-EBSD maps

## INPUTS
- data.mat: contains the HR-EBSD analysis findings as the input to ASA
  - Data: the data structure for the EBSD data
  - Map: the data structure for the stress results (HR-EBSD analysis)
  - num_ref: the number of reference points

- input.m: some inputs for the analysis
  - folder: folder name of the data file
  - file: file name of the data file
  - lambda: penalty factor for equilibrium
  - minCI: minimum confidence index for a bad data point
  - minIQ: minimum image quality for a bad data point
  - minNIndexedBands: minimum number of indexed bands for a bad data point

## EXAMPLE
Synthetic uniform elastic bending strain applied to a polycrytal with 71 grains 

## OUTPUTS
- Main outputs
  - sigma: stress components at each dof
  - sigma_ref: reference point stresses

## POSTPROCESSING
- Copy scripts from
  - outputs.m
  - output_ref.m
