'# MWS Version: Version 2021.1 - Nov 10 2020 - ACIS 30.0.1 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 4 fmax = 8
'# created = '[VERSION]2021.1|30.0.1|20201110[/VERSION]


'@ use template: Antenna - Planar.cfg

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
'set the units
With Units
    .Geometry "mm"
    .Frequency "GHz"
    .Voltage "V"
    .Resistance "Ohm"
    .Inductance "H"
    .TemperatureUnit  "Kelvin"
    .Time "ns"
    .Current "A"
    .Conductance "Siemens"
    .Capacitance "F"
End With

'----------------------------------------------------------------------------

'set the frequency range
Solver.FrequencyRange "4", "8"

'----------------------------------------------------------------------------

Plot.DrawBox True

With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mu "1.0"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With

With Boundary
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "expanded open"
     .Ymax "expanded open"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
End With

' optimize mesh settings for planar structures

With Mesh
     .MergeThinPECLayerFixpoints "True"
     .RatioLimit "20"
     .AutomeshRefineAtPecLines "True", "6"
     .FPBAAvoidNonRegUnite "True"
     .ConsiderSpaceForLowerMeshLimit "False"
     .MinimumStepNumber "5"
     .AnisotropicCurvatureRefinement "True"
     .AnisotropicCurvatureRefinementFSM "True"
End With

With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "20"
     .Set "EdgeRefinementOn", "1"
     .Set "EdgeRefinementRatio", "6"
End With

With MeshSettings
     .SetMeshType "HexTLM"
     .Set "RatioLimitGeometry", "20"
End With

With MeshSettings
     .SetMeshType "Tet"
     .Set "VolMeshGradation", "1.5"
     .Set "SrfMeshGradation", "1.5"
End With

' change mesh adaption scheme to energy
' 		(planar structures tend to store high energy
'     	 locally at edges rather than globally in volume)

MeshAdaption3D.SetAdaptionStrategy "Energy"

' switch on FD-TET setting for accurate farfields

FDSolver.ExtrudeOpenBC "True"

PostProcess1D.ActivateOperation "vswr", "true"
PostProcess1D.ActivateOperation "yz-matrices", "true"

With FarfieldPlot
	.ClearCuts ' lateral=phi, polar=theta
	.AddCut "lateral", "0", "1"
	.AddCut "lateral", "90", "1"
	.AddCut "polar", "90", "1"
End With

'----------------------------------------------------------------------------

Dim sDefineAt As String
sDefineAt = "4;6;8"
Dim sDefineAtName As String
sDefineAtName = "4;6;8"
Dim sDefineAtToken As String
sDefineAtToken = "f="
Dim aFreq() As String
aFreq = Split(sDefineAt, ";")
Dim aNames() As String
aNames = Split(sDefineAtName, ";")

Dim nIndex As Integer
For nIndex = LBound(aFreq) To UBound(aFreq)

Dim zz_val As String
zz_val = aFreq (nIndex)
Dim zz_name As String
zz_name = sDefineAtToken & aNames (nIndex)

' Define E-Field Monitors
With Monitor
    .Reset
    .Name "e-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Efield"
    .MonitorValue  zz_val
    .Create
End With

' Define H-Field Monitors
With Monitor
    .Reset
    .Name "h-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Hfield"
    .MonitorValue  zz_val
    .Create
End With

' Define Power flow Monitors
With Monitor
    .Reset
    .Name "power ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Powerflow"
    .MonitorValue  zz_val
    .Create
End With

' Define Power loss Monitors
With Monitor
    .Reset
    .Name "loss ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Powerloss"
    .MonitorValue  zz_val
    .Create
End With

' Define Farfield Monitors
With Monitor
    .Reset
    .Name "farfield ("& zz_name &")"
    .Domain "Frequency"
    .FieldType "Farfield"
    .MonitorValue  zz_val
    .ExportFarfieldSource "False"
    .Create
End With

Next

'----------------------------------------------------------------------------

With MeshSettings
     .SetMeshType "Tet"
     .Set "Version", 1%
End With

With Mesh
     .MeshType "Tetrahedral"
End With

'set the solver type
ChangeSolverType("HF Frequency Domain")

'----------------------------------------------------------------------------

'@ define material: Copper (annealed)

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Material
     .Reset
     .Name "Copper (annealed)"
     .Folder ""
.FrqType "static"
.Type "Normal"
.SetMaterialUnit "Hz", "mm"
.Epsilon "1"
.Mu "1.0"
.Kappa "5.8e+007"
.TanD "0.0"
.TanDFreq "0.0"
.TanDGiven "False"
.TanDModel "ConstTanD"
.KappaM "0"
.TanDM "0.0"
.TanDMFreq "0.0"
.TanDMGiven "False"
.TanDMModel "ConstTanD"
.DispModelEps "None"
.DispModelMu "None"
.DispersiveFittingSchemeEps "Nth Order"
.DispersiveFittingSchemeMu "Nth Order"
.UseGeneralDispersionEps "False"
.UseGeneralDispersionMu "False"
.FrqType "all"
.Type "Lossy metal"
.SetMaterialUnit "GHz", "mm"
.Mu "1.0"
.Kappa "5.8e+007"
.Rho "8930.0"
.ThermalType "Normal"
.ThermalConductivity "401.0"
.SpecificHeat "390", "J/K/kg"
.MetabolicRate "0"
.BloodFlow "0"
.VoxelConvection "0"
.MechanicsType "Isotropic"
.YoungsModulus "120"
.PoissonsRatio "0.33"
.ThermalExpansionRate "17"
.Colour "1", "1", "0"
.Wireframe "False"
.Reflection "False"
.Allowoutline "True"
.Transparentoutline "False"
.Transparency "0"
.Create
End With

'@ new component: component1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Component.New "component1"

'@ define brick: component1:ground

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "ground" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-width/2", "width/2" 
     .Yrange "-length/2", "length/2" 
     .Zrange "-0.035", "0" 
     .Create
End With

'@ define material: FR-4 (lossy)

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Material
     .Reset
     .Name "FR-4 (lossy)"
     .Folder ""
.FrqType "all"
.Type "Normal"
.SetMaterialUnit "GHz", "mm"
.Epsilon "4.3"
.Mu "1.0"
.Kappa "0.0"
.TanD "0.025"
.TanDFreq "10.0"
.TanDGiven "True"
.TanDModel "ConstTanD"
.KappaM "0.0"
.TanDM "0.0"
.TanDMFreq "0.0"
.TanDMGiven "False"
.TanDMModel "ConstKappa"
.DispModelEps "None"
.DispModelMu "None"
.DispersiveFittingSchemeEps "General 1st"
.DispersiveFittingSchemeMu "General 1st"
.UseGeneralDispersionEps "False"
.UseGeneralDispersionMu "False"
.Rho "0.0"
.ThermalType "Normal"
.ThermalConductivity "0.3"
.SetActiveMaterial "all"
.Colour "0.94", "0.82", "0.76"
.Wireframe "False"
.Transparency "0"
.Create
End With

'@ define brick: component1:substrate

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "substrate" 
     .Component "component1" 
     .Material "FR-4 (lossy)" 
     .Xrange "-width/2", "width/2" 
     .Yrange "-length/2", "length/2" 
     .Zrange "0", "d" 
     .Create
End With

'@ define cylinder: component1:ring

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Cylinder 
     .Reset 
     .Name "ring" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .OuterRadius "r+msl/2" 
     .InnerRadius "r-msl/2" 
     .Axis "z" 
     .Zrange "d+0.035+d_sample", "d+0.035+d_sample+0.035" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ define brick: component1:MSL

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "MSL" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-msl/2", "msl/2" 
     .Yrange "-length/2", "length/2" 
     .Zrange "d", "d+0.035" 
     .Create
End With

'@ boolean insert shapes: component1:MSL, component1:ring

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Insert "component1:MSL", "component1:ring"

'@ pick face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickFaceFromId "component1:MSL", "5"

'@ set shape accuracy

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.ShapeVisualizationAccuracy2 "120" 
Solid.ShapeVisualizationOffset "0" 
Pick.ClearAllPicks

'@ switch working plane

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Plot.DrawWorkplane "false"

'@ switch bounding box

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Plot.DrawBox "False"

'@ clear picks

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ClearAllPicks

'@ define port: 1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Port 
     .Reset 
     .PortNumber "1" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "1"
     .Coordinates "Free"
     .Orientation "ymin"
     .PortOnBound "False"
     .ClipPickedPortToBound "False"
     .Xrange "-k*msl", "k*msl"
     .Yrange "-length/2", "-length/2"
     .Zrange "0", "d+0.035+K*msl"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "0.0", "0.0"
     .ZrangeAdd "0.0", "0.0"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ modify port: 1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Port 
     .Reset 
     .LoadContentForModify "1" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "1"
     .Coordinates "Free"
     .Orientation "ymin"
     .PortOnBound "False"
     .ClipPickedPortToBound "False"
     .Xrange "-k*msl", "k*msl"
     .Yrange "-length/2", "-length/2"
     .Zrange "0", "d+0.035+k*msl"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "0.0", "0.0"
     .ZrangeAdd "0.0", "0.0"
     .SingleEnded "False"
     .Shield "none"
     .WaveguideMonitor "False"
     .Modify 
End With

'@ define port: 2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Port 
     .Reset 
     .PortNumber "2" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "1"
     .Coordinates "Free"
     .Orientation "ymax"
     .PortOnBound "False"
     .ClipPickedPortToBound "False"
     .Xrange "-k*msl", "k+msl"
     .Yrange "length/2", "length/2"
     .Zrange "0", "d+k*msl"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "0.0", "0.0"
     .ZrangeAdd "0.0", "0.0"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ modify port: 1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Port 
     .Reset 
     .LoadContentForModify "1" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "1"
     .Coordinates "Free"
     .Orientation "ymin"
     .PortOnBound "False"
     .ClipPickedPortToBound "False"
     .Xrange "-k*msl", "k*msl"
     .Yrange "-length/2", "-length/2"
     .Zrange "0", "d+k*msl"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "0.0", "0.0"
     .ZrangeAdd "0.0", "0.0"
     .SingleEnded "False"
     .Shield "none"
     .WaveguideMonitor "False"
     .Modify 
End With

'@ define frequency range

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solver.FrequencyRange "4", "8"

'@ define pml specials

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Boundary
     .ReflectionLevel "0.0001" 
     .MinimumDistanceType "Fraction" 
     .MinimumDistancePerWavelengthNewMeshEngine "4" 
     .MinimumDistanceReferenceFrequencyType "Center" 
     .FrequencyForMinimumDistance "6" 
     .SetAbsoluteDistance "0.0" 
End With

'@ delete monitors

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Monitor.Delete "e-field (f=4)" 
Monitor.Delete "e-field (f=8)" 
Monitor.Delete "farfield (f=4)" 
Monitor.Delete "farfield (f=8)" 
Monitor.Delete "h-field (f=4)" 
Monitor.Delete "h-field (f=8)" 
Monitor.Delete "loss (f=4)" 
Monitor.Delete "loss (f=6)" 
Monitor.Delete "loss (f=8)" 
Monitor.Delete "power (f=4)" 
Monitor.Delete "power (f=6)" 
Monitor.Delete "power (f=8)"

'@ switch bounding box

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Plot.DrawBox "False"

'@ define frequency domain solver parameters

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Mesh.SetCreator "High Frequency" 

With FDSolver
     .Reset 
     .SetMethod "Tetrahedral", "General purpose" 
     .OrderTet "Second" 
     .OrderSrf "First" 
     .Stimulation "All", "All" 
     .ResetExcitationList 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .ConsiderPortLossesTet "True" 
     .SetShieldAllPorts "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-4" 
     .AccuracySrf "1e-3" 
     .LimitIterations "False" 
     .MaxIterations "0" 
     .SetCalcBlockExcitationsInParallel "True", "True", "" 
     .StoreAllResults "False" 
     .StoreResultsInCache "False" 
     .UseHelmholtzEquation "True" 
     .LowFrequencyStabilization "True" 
     .Type "Auto" 
     .MeshAdaptionHex "False" 
     .MeshAdaptionTet "True" 
     .AcceleratedRestart "True" 
     .FreqDistAdaptMode "Distributed" 
     .NewIterativeSolver "True" 
     .TDCompatibleMaterials "False" 
     .ExtrudeOpenBC "True" 
     .SetOpenBCTypeHex "Default" 
     .SetOpenBCTypeTet "Default" 
     .AddMonitorSamples "True" 
     .CalcPowerLoss "True" 
     .CalcPowerLossPerComponent "False" 
     .StoreSolutionCoefficients "True" 
     .UseDoublePrecision "False" 
     .UseDoublePrecision_ML "True" 
     .MixedOrderSrf "False" 
     .MixedOrderTet "False" 
     .PreconditionerAccuracyIntEq "0.15" 
     .MLFMMAccuracy "Default" 
     .MinMLFMMBoxSize "0.3" 
     .UseCFIEForCPECIntEq "True" 
     .UseFastRCSSweepIntEq "false" 
     .UseSensitivityAnalysis "False" 
     .RemoveAllStopCriteria "Hex"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Hex", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Hex", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Hex", "False"
     .RemoveAllStopCriteria "Tet"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Tet", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "All Probes", "0.05", "2", "Tet", "True"
     .RemoveAllStopCriteria "Srf"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Srf", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Srf", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Srf", "False"
     .SweepMinimumSamples "3" 
     .SetNumberOfResultDataSamples "1001" 
     .SetResultDataSamplingMode "Automatic" 
     .SweepWeightEvanescent "1.0" 
     .AccuracyROM "1e-4" 
     .AddSampleInterval "", "", "1", "Automatic", "True" 
     .AddSampleInterval "4", "8", "9", "Equidistant", "False" 
     .MPIParallelization "False"
     .UseDistributedComputing "False"
     .NetworkComputingStrategy "RunRemote"
     .NetworkComputingJobCount "3"
     .UseParallelization "True"
     .MaxCPUs "1024"
     .MaximumNumberOfCPUDevices "2"
End With

With IESolver
     .Reset 
     .UseFastFrequencySweep "True" 
     .UseIEGroundPlane "False" 
     .SetRealGroundMaterialName "" 
     .CalcFarFieldInRealGround "False" 
     .RealGroundModelType "Auto" 
     .PreconditionerType "Auto" 
     .ExtendThinWireModelByWireNubs "False" 
     .ExtraPreconditioning "False" 
End With

With IESolver
     .SetFMMFFCalcStopLevel "0" 
     .SetFMMFFCalcNumInterpPoints "6" 
     .UseFMMFarfieldCalc "True" 
     .SetCFIEAlpha "0.500000" 
     .LowFrequencyStabilization "False" 
     .LowFrequencyStabilizationML "True" 
     .Multilayer "False" 
     .SetiMoMACC_I "0.0001" 
     .SetiMoMACC_M "0.0001" 
     .DeembedExternalPorts "True" 
     .SetOpenBC_XY "True" 
     .OldRCSSweepDefintion "False" 
     .SetRCSOptimizationProperties "True", "100", "0.00001" 
     .SetAccuracySetting "Custom" 
     .CalculateSParaforFieldsources "True" 
     .ModeTrackingCMA "True" 
     .NumberOfModesCMA "3" 
     .StartFrequencyCMA "-1.0" 
     .SetAccuracySettingCMA "Default" 
     .FrequencySamplesCMA "0" 
     .SetMemSettingCMA "Auto" 
     .CalculateModalWeightingCoefficientsCMA "True" 
End With

'@ define brick: component1:solid1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "-msl/2", "msl/2" 
     .Yrange "-r-msl/2-g", "r+msl/2+g" 
     .Zrange "d", "d+0.035" 
     .Create
End With

'@ boolean subtract shapes: component1:MSL, component1:solid1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Subtract "component1:MSL", "component1:solid1"

'@ define brick: component1:upper_support

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "upper_support" 
     .Component "component1" 
     .Material "FR-4 (lossy)" 
     .Xrange "-width/2", "width/2" 
     .Yrange "-length/2", "length/2" 
     .Zrange "d+0.035+d_sample+0.035", "d+0.035+d_sample+0.035+d" 
     .Create
End With

'@ define brick: component1:sample

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "sample" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "-w_sample/2", "w_sample/2" 
     .Yrange "-l_sample/2", "l_sample/2" 
     .Zrange "d+0.035", "d+0.035+d_sample" 
     .Create
End With

'@ modify port: 1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Port 
     .Reset 
     .LoadContentForModify "1" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "1"
     .Coordinates "Free"
     .Orientation "ymin"
     .PortOnBound "False"
     .ClipPickedPortToBound "False"
     .Xrange "-k*msl", "k*msl"
     .Yrange "-length/2", "-length/2"
     .Zrange "-0.035", "d+0.035+k*msl"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "0.0", "0.0"
     .ZrangeAdd "0.0", "0.0"
     .SingleEnded "False"
     .Shield "none"
     .WaveguideMonitor "False"
     .Modify 
End With

'@ modify port: 2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Port 
     .Reset 
     .LoadContentForModify "2" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "1"
     .Coordinates "Free"
     .Orientation "ymax"
     .PortOnBound "False"
     .ClipPickedPortToBound "False"
     .Xrange "-k*msl", "k+msl"
     .Yrange "length/2", "length/2"
     .Zrange "-0.035", "d+0.035+k*msl"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "0.0", "0.0"
     .ZrangeAdd "0.0", "0.0"
     .SingleEnded "False"
     .Shield "none"
     .WaveguideMonitor "False"
     .Modify 
End With

'@ define frequency range

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solver.FrequencyRange "4", "8"

'@ modify port: 2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Port 
     .Reset 
     .LoadContentForModify "2" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "1"
     .Coordinates "Free"
     .Orientation "ymax"
     .PortOnBound "False"
     .ClipPickedPortToBound "False"
     .Xrange "-k*msl", "k*msl"
     .Yrange "length/2", "length/2"
     .Zrange "-0.035", "d+0.035+k*msl"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "0.0", "0.0"
     .ZrangeAdd "0.0", "0.0"
     .SingleEnded "False"
     .Shield "none"
     .WaveguideMonitor "False"
     .Modify 
End With

'@ define frequency range

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solver.FrequencyRange "4", "8"

'@ switch bounding box

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Plot.DrawBox "True"

'@ clear picks

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ClearAllPicks

'@ pick edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEdgeFromId "component1:MSL", "17", "13"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "0"
    .SetOrientation "Smart Mode"
    .SetDistance "5.476971"
    .SetViewVector "-0.000059", "0.000000", "-1.000000"
    .SetConnectedElement1 "component1:MSL"
    .SetConnectedElement2 "component1:MSL"
    .Create
End With

Pick.ClearAllPicks

'@ pick edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEdgeFromId "component1:MSL", "39", "28"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "1"
    .SetOrientation "Smart Mode"
    .SetDistance "5.477278"
    .SetViewVector "-0.000059", "0.000000", "-1.000000"
    .SetConnectedElement1 "component1:MSL"
    .SetConnectedElement2 "component1:MSL"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:MSL", "28"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:MSL", "26"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "2"
    .SetOrientation "Smart Mode"
    .SetDistance "-1.733787"
    .SetViewVector "-0.000019", "0.000000", "-1.000000"
    .SetConnectedElement1 "component1:MSL"
    .SetConnectedElement2 "component1:MSL"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:MSL", "23"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:MSL", "22"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "3"
    .SetOrientation "Smart Mode"
    .SetDistance "4.103689"
    .SetViewVector "-0.000019", "0.000000", "-1.000000"
    .SetConnectedElement1 "component1:MSL"
    .SetConnectedElement2 "component1:MSL"
    .Create
End With

Pick.ClearAllPicks

'@ change solver type

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
ChangeSolverType "HF Time Domain"

'@ define time domain solver parameters

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Mesh.SetCreator "High Frequency" 

With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-40"
     .MeshAdaption "False"
     .AutoNormImpedance "False"
     .NormingImpedance "50"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

'@ change solver type

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
ChangeSolverType "HF Frequency Domain"

'@ define frequency domain solver parameters

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Mesh.SetCreator "High Frequency" 

With FDSolver
     .Reset 
     .SetMethod "Tetrahedral", "General purpose" 
     .OrderTet "Second" 
     .OrderSrf "First" 
     .Stimulation "All", "All" 
     .ResetExcitationList 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .ConsiderPortLossesTet "True" 
     .SetShieldAllPorts "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-4" 
     .AccuracySrf "1e-3" 
     .LimitIterations "False" 
     .MaxIterations "0" 
     .SetCalcBlockExcitationsInParallel "True", "True", "" 
     .StoreAllResults "False" 
     .StoreResultsInCache "False" 
     .UseHelmholtzEquation "True" 
     .LowFrequencyStabilization "True" 
     .Type "Auto" 
     .MeshAdaptionHex "False" 
     .MeshAdaptionTet "True" 
     .AcceleratedRestart "True" 
     .FreqDistAdaptMode "Distributed" 
     .NewIterativeSolver "True" 
     .TDCompatibleMaterials "False" 
     .ExtrudeOpenBC "True" 
     .SetOpenBCTypeHex "Default" 
     .SetOpenBCTypeTet "Default" 
     .AddMonitorSamples "True" 
     .CalcPowerLoss "True" 
     .CalcPowerLossPerComponent "False" 
     .StoreSolutionCoefficients "True" 
     .UseDoublePrecision "False" 
     .UseDoublePrecision_ML "True" 
     .MixedOrderSrf "False" 
     .MixedOrderTet "False" 
     .PreconditionerAccuracyIntEq "0.15" 
     .MLFMMAccuracy "Default" 
     .MinMLFMMBoxSize "0.3" 
     .UseCFIEForCPECIntEq "True" 
     .UseFastRCSSweepIntEq "false" 
     .UseSensitivityAnalysis "False" 
     .RemoveAllStopCriteria "Hex"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Hex", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Hex", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Hex", "False"
     .RemoveAllStopCriteria "Tet"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Tet", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "All Probes", "0.05", "2", "Tet", "True"
     .RemoveAllStopCriteria "Srf"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Srf", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Srf", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Srf", "False"
     .SweepMinimumSamples "3" 
     .SetNumberOfResultDataSamples "1001" 
     .SetResultDataSamplingMode "Automatic" 
     .SweepWeightEvanescent "1.0" 
     .AccuracyROM "1e-4" 
     .AddSampleInterval "", "", "1", "Automatic", "True" 
     .AddSampleInterval "4", "8", "9", "Equidistant", "False" 
     .MPIParallelization "False"
     .UseDistributedComputing "False"
     .NetworkComputingStrategy "RunRemote"
     .NetworkComputingJobCount "3"
     .UseParallelization "True"
     .MaxCPUs "1024"
     .MaximumNumberOfCPUDevices "2"
End With

With IESolver
     .Reset 
     .UseFastFrequencySweep "True" 
     .UseIEGroundPlane "False" 
     .SetRealGroundMaterialName "" 
     .CalcFarFieldInRealGround "False" 
     .RealGroundModelType "Auto" 
     .PreconditionerType "Auto" 
     .ExtendThinWireModelByWireNubs "False" 
     .ExtraPreconditioning "False" 
End With

With IESolver
     .SetFMMFFCalcStopLevel "0" 
     .SetFMMFFCalcNumInterpPoints "6" 
     .UseFMMFarfieldCalc "True" 
     .SetCFIEAlpha "0.500000" 
     .LowFrequencyStabilization "False" 
     .LowFrequencyStabilizationML "True" 
     .Multilayer "False" 
     .SetiMoMACC_I "0.0001" 
     .SetiMoMACC_M "0.0001" 
     .DeembedExternalPorts "True" 
     .SetOpenBC_XY "True" 
     .OldRCSSweepDefintion "False" 
     .SetRCSOptimizationProperties "True", "100", "0.00001" 
     .SetAccuracySetting "Custom" 
     .CalculateSParaforFieldsources "True" 
     .ModeTrackingCMA "True" 
     .NumberOfModesCMA "3" 
     .StartFrequencyCMA "-1.0" 
     .SetAccuracySettingCMA "Default" 
     .FrequencySamplesCMA "0" 
     .SetMemSettingCMA "Auto" 
     .CalculateModalWeightingCoefficientsCMA "True" 
End With

'@ change solver type

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
ChangeSolverType "HF Time Domain"

'@ define time domain solver parameters

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Mesh.SetCreator "High Frequency" 

With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-40"
     .MeshAdaption "False"
     .AutoNormImpedance "False"
     .NormingImpedance "50"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

'@ change solver type

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
ChangeSolverType "HF Frequency Domain"

'@ define frequency domain solver parameters

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Mesh.SetCreator "High Frequency" 

With FDSolver
     .Reset 
     .SetMethod "Tetrahedral", "General purpose" 
     .OrderTet "Second" 
     .OrderSrf "First" 
     .Stimulation "All", "All" 
     .ResetExcitationList 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .ConsiderPortLossesTet "True" 
     .SetShieldAllPorts "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-4" 
     .AccuracySrf "1e-3" 
     .LimitIterations "False" 
     .MaxIterations "0" 
     .SetCalcBlockExcitationsInParallel "True", "True", "" 
     .StoreAllResults "False" 
     .StoreResultsInCache "False" 
     .UseHelmholtzEquation "True" 
     .LowFrequencyStabilization "True" 
     .Type "Auto" 
     .MeshAdaptionHex "False" 
     .MeshAdaptionTet "True" 
     .AcceleratedRestart "True" 
     .FreqDistAdaptMode "Distributed" 
     .NewIterativeSolver "True" 
     .TDCompatibleMaterials "False" 
     .ExtrudeOpenBC "True" 
     .SetOpenBCTypeHex "Default" 
     .SetOpenBCTypeTet "Default" 
     .AddMonitorSamples "True" 
     .CalcPowerLoss "True" 
     .CalcPowerLossPerComponent "False" 
     .StoreSolutionCoefficients "True" 
     .UseDoublePrecision "False" 
     .UseDoublePrecision_ML "True" 
     .MixedOrderSrf "False" 
     .MixedOrderTet "False" 
     .PreconditionerAccuracyIntEq "0.15" 
     .MLFMMAccuracy "Default" 
     .MinMLFMMBoxSize "0.3" 
     .UseCFIEForCPECIntEq "True" 
     .UseFastRCSSweepIntEq "false" 
     .UseSensitivityAnalysis "False" 
     .RemoveAllStopCriteria "Hex"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Hex", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Hex", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Hex", "False"
     .RemoveAllStopCriteria "Tet"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Tet", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "All Probes", "0.05", "2", "Tet", "True"
     .RemoveAllStopCriteria "Srf"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Srf", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Srf", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Srf", "False"
     .SweepMinimumSamples "3" 
     .SetNumberOfResultDataSamples "1001" 
     .SetResultDataSamplingMode "Automatic" 
     .SweepWeightEvanescent "1.0" 
     .AccuracyROM "1e-4" 
     .AddSampleInterval "", "", "1", "Automatic", "True" 
     .AddSampleInterval "4", "8", "9", "Equidistant", "False" 
     .MPIParallelization "False"
     .UseDistributedComputing "False"
     .NetworkComputingStrategy "RunRemote"
     .NetworkComputingJobCount "3"
     .UseParallelization "True"
     .MaxCPUs "1024"
     .MaximumNumberOfCPUDevices "2"
End With

With IESolver
     .Reset 
     .UseFastFrequencySweep "True" 
     .UseIEGroundPlane "False" 
     .SetRealGroundMaterialName "" 
     .CalcFarFieldInRealGround "False" 
     .RealGroundModelType "Auto" 
     .PreconditionerType "Auto" 
     .ExtendThinWireModelByWireNubs "False" 
     .ExtraPreconditioning "False" 
End With

With IESolver
     .SetFMMFFCalcStopLevel "0" 
     .SetFMMFFCalcNumInterpPoints "6" 
     .UseFMMFarfieldCalc "True" 
     .SetCFIEAlpha "0.500000" 
     .LowFrequencyStabilization "False" 
     .LowFrequencyStabilizationML "True" 
     .Multilayer "False" 
     .SetiMoMACC_I "0.0001" 
     .SetiMoMACC_M "0.0001" 
     .DeembedExternalPorts "True" 
     .SetOpenBC_XY "True" 
     .OldRCSSweepDefintion "False" 
     .SetRCSOptimizationProperties "True", "100", "0.00001" 
     .SetAccuracySetting "Custom" 
     .CalculateSParaforFieldsources "True" 
     .ModeTrackingCMA "True" 
     .NumberOfModesCMA "3" 
     .StartFrequencyCMA "-1.0" 
     .SetAccuracySettingCMA "Default" 
     .FrequencySamplesCMA "0" 
     .SetMemSettingCMA "Auto" 
     .CalculateModalWeightingCoefficientsCMA "True" 
End With

'@ define cylinder: component1:ringHole

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Cylinder 
     .Reset 
     .Name "ringHole" 
     .Component "component1" 
     .Material "Vacuum" 
     .OuterRadius "0.67*r" 
     .InnerRadius "0" 
     .Axis "z" 
     .Zrange "d+0.035+d_sample", "d+0.035+d_sample+0.035+d" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ boolean subtract shapes: component1:upper_support, component1:ringHole

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Subtract "component1:upper_support", "component1:ringHole"

'@ pick edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEdgeFromId "component1:MSL", "19", "15"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "4"
    .SetOrientation "Smart Mode"
    .SetDistance "-1.298328"
    .SetViewVector "-0.000020", "0.000000", "-1.000000"
    .SetConnectedElement1 "component1:MSL"
    .SetConnectedElement2 "component1:MSL"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickExtraCirclepointFromId "component1:ring", "3", "3", "0"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickExtraCirclepointFromId "component1:ring", "4", "4", "0"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "5"
    .SetOrientation "Smart Mode"
    .SetDistance "-11.144289"
    .SetViewVector "-0.000026", "0.000000", "-1.000000"
    .SetConnectedElement1 ""
    .SetConnectedElement2 ""
    .Create
End With

Pick.ClearAllPicks

'@ pick edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEdgeFromId "component1:ring", "4", "4"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "6"
    .SetOrientation "Smart Mode"
    .SetDistance "14.223405"
    .SetViewVector "-0.000030", "0.003491", "-0.999994"
    .SetConnectedElement1 "component1:ring"
    .SetConnectedElement2 "component1:ring"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:ring", "4"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:ring", "3"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "7"
    .SetOrientation "Smart Mode"
    .SetDistance "-14.696920"
    .SetViewVector "-0.000040", "0.003491", "-0.999994"
    .SetConnectedElement1 "component1:ring"
    .SetConnectedElement2 "component1:ring"
    .Create
End With

Pick.ClearAllPicks

'@ pick edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEdgeFromId "component1:sample", "3", "3"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "8"
    .SetOrientation "Smart Mode"
    .SetDistance "2.880565"
    .SetViewVector "-0.000046", "0.003491", "-0.999994"
    .SetConnectedElement1 "component1:sample"
    .SetConnectedElement2 "component1:sample"
    .Create
End With

Pick.ClearAllPicks

'@ pick edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEdgeFromId "component1:ground", "2", "2"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "9"
    .SetOrientation "Smart Mode"
    .SetDistance "17.192879"
    .SetViewVector "-0.000046", "0.003491", "-0.999994"
    .SetConnectedElement1 "component1:ground"
    .SetConnectedElement2 "component1:ground"
    .Create
End With

Pick.ClearAllPicks

'@ pick edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEdgeFromId "component1:ground", "3", "3"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "10"
    .SetOrientation "Smart Mode"
    .SetDistance "7.278157"
    .SetViewVector "-0.000070", "0.003491", "-0.999994"
    .SetConnectedElement1 "component1:ground"
    .SetConnectedElement2 "component1:ground"
    .Create
End With

Pick.ClearAllPicks

'@ pick edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEdgeFromId "component1:MSL", "19", "15"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "11"
    .SetOrientation "Smart Mode"
    .SetDistance "1.881641"
    .SetViewVector "-0.000040", "0.003491", "-0.999994"
    .SetConnectedElement1 "component1:MSL"
    .SetConnectedElement2 "component1:MSL"
    .Create
End With

Pick.ClearAllPicks

'@ new component: component2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Component.New "component2"

'@ define cylinder: component2:foro1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Cylinder 
     .Reset 
     .Name "foro1" 
     .Component "component2" 
     .Material "Vacuum" 
     .OuterRadius "2" 
     .InnerRadius "0" 
     .Axis "z" 
     .Zrange "-85", "85" 
     .Xcenter "9" 
     .Ycenter "21" 
     .Segments "0" 
     .Create 
End With

'@ clear picks

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ClearAllPicks

'@ boolean insert shapes: component1:ground, component2:foro1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Solid
     .Version 10
     .Insert "component1:ground", "component2:foro1" 
     .Version 1
End With

'@ boolean insert shapes: component1:substrate, component2:foro1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Solid
     .Version 10
     .Insert "component1:substrate", "component2:foro1" 
     .Version 1
End With

'@ boolean subtract shapes: component1:upper_support, component2:foro1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Subtract "component1:upper_support", "component2:foro1"

'@ define cylinder: component2:foro2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Cylinder 
     .Reset 
     .Name "foro2" 
     .Component "component2" 
     .Material "Vacuum" 
     .OuterRadius "2" 
     .InnerRadius "0.0" 
     .Axis "z" 
     .Zrange "-85", "85" 
     .Xcenter "-9" 
     .Ycenter "21" 
     .Segments "0" 
     .Create 
End With

'@ boolean insert shapes: component1:ground, component2:foro2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Solid
     .Version 10
     .Insert "component1:ground", "component2:foro2" 
     .Version 1
End With

'@ boolean insert shapes: component1:substrate, component2:foro2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Solid
     .Version 10
     .Insert "component1:substrate", "component2:foro2" 
     .Version 1
End With

'@ boolean subtract shapes: component1:upper_support, component2:foro2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Subtract "component1:upper_support", "component2:foro2"

'@ define cylinder: component2:foro3

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Cylinder 
     .Reset 
     .Name "foro3" 
     .Component "component2" 
     .Material "Vacuum" 
     .OuterRadius "2" 
     .InnerRadius "0" 
     .Axis "z" 
     .Zrange "-85", "85" 
     .Xcenter "9" 
     .Ycenter "-21" 
     .Segments "0" 
     .Create 
End With

'@ boolean insert shapes: component1:ground, component2:foro3

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Solid
     .Version 10
     .Insert "component1:ground", "component2:foro3" 
     .Version 1
End With

'@ boolean insert shapes: component1:substrate, component2:foro3

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Solid
     .Version 10
     .Insert "component1:substrate", "component2:foro3" 
     .Version 1
End With

'@ boolean subtract shapes: component1:upper_support, component2:foro3

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Subtract "component1:upper_support", "component2:foro3"

'@ define cylinder: component2:foro4

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Cylinder 
     .Reset 
     .Name "foro4" 
     .Component "component2" 
     .Material "Vacuum" 
     .OuterRadius "2" 
     .InnerRadius "0" 
     .Axis "z" 
     .Zrange "-85", "85" 
     .Xcenter "-9" 
     .Ycenter "-21" 
     .Segments "0" 
     .Create 
End With

'@ boolean insert shapes: component1:ground, component2:foro4

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Solid
     .Version 10
     .Insert "component1:ground", "component2:foro4" 
     .Version 1
End With

'@ boolean insert shapes: component1:substrate, component2:foro4

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Solid
     .Version 10
     .Insert "component1:substrate", "component2:foro4" 
     .Version 1
End With

'@ boolean subtract shapes: component1:upper_support, component2:foro4

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Subtract "component1:upper_support", "component2:foro4"

'@ activate local coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "local"

'@ align wcs with point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:upper_support", "20" 
WCS.AlignWCSWithSelectedPoint

'@ activate global coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "global"

'@ align wcs with face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ForceNextPick 
Pick.PickFaceFromId "component1:upper_support", "16" 
WCS.AlignWCSWithSelected "Face"

'@ activate global coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "global"

'@ align wcs with face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ForceNextPick 
Pick.PickFaceFromId "component1:upper_support", "17" 
WCS.AlignWCSWithSelected "Face"

'@ activate global coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "global"

'@ activate local coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "local"

'@ align wcs with face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ForceNextPick 
Pick.PickFaceFromId "component1:upper_support", "17" 
WCS.AlignWCSWithSelected "Face"

'@ activate global coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "global"

'@ align wcs with face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ForceNextPick 
Pick.PickFaceFromId "component1:ground", "13" 
WCS.AlignWCSWithSelected "Face"

'@ activate global coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "global"

'@ align wcs with face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ForceNextPick 
Pick.PickFaceFromId "component1:substrate", "13" 
WCS.AlignWCSWithSelected "Face"

'@ activate global coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "global"

'@ activate local coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "local"

'@ align wcs with face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ForceNextPick 
Pick.PickFaceFromId "component1:upper_support", "14" 
WCS.AlignWCSWithSelected "Face"

'@ activate global coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "global"

'@ activate local coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "local"

'@ align wcs with face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ForceNextPick 
Pick.PickFaceFromId "component1:upper_support", "14" 
WCS.AlignWCSWithSelected "Face"

'@ activate global coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "global"

'@ define material: Vacuum

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Material 
     .Reset 
     .Name "Vacuum"
     .Folder ""
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "Hz"
     .MaterialUnit "Geometry", "m"
     .MaterialUnit "Time", "s"
     .MaterialUnit "Temperature", "Kelvin"
     .Epsilon "1"
     .Mu "1.0"
     .Sigma "0"
     .TanD ""
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .SetConstTanDStrategyEps "AutomaticOrder"
     .ConstTanDModelOrderEps "3"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .SetConstTanDStrategyMu "AutomaticOrder"
     .ConstTanDModelOrderMu "3"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps  "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .MaximalOrderNthModelFitEps "10"
     .ErrorLimitNthModelFitEps "0.1"
     .UseOnlyDataInSimFreqRangeNthModelEps "False"
     .DispersiveFittingSchemeMu "Nth Order"
     .MaximalOrderNthModelFitMu "10"
     .ErrorLimitNthModelFitMu "0.1"
     .UseOnlyDataInSimFreqRangeNthModelMu "False"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "0.5", "0.8", "1" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With

'@ define material colour: Vacuum

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Material 
     .Name "Vacuum"
     .Folder ""
     .Colour "0.5", "0.8", "1" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .ChangeColour 
End With

'@ switch working plane

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Plot.DrawWorkplane "false"

'@ switch bounding box

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Plot.DrawBox "False"

