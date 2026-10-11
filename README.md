# 6 GHz Ring Resonator for material characterisation

Final project for the **Electromagnetic Therapy, Exposure and Compatibility** course (*Terapia, Esposizione e Compatibilità Elettromagnetica*, TECE), A.Y. 2024/2025  
Prof. C. Occhiuzzi – Tutor: Eng. F. Lestini  
Authors: Silvia Gialloreto, Irene Lorusso, Valerio Luzi

Design in **CST Studio Suite**, prototyping and measurement of a **6 GHz microstrip ring resonator on FR-4** for the dielectric characterisation (ε<sub>r</sub>, σ) of samples placed on top of the ring. The resonance frequency and the quality factor Q are extracted from the S21 curve measured with a VNA and compared with the simulations.

---

## Repository structure

```
ring-resonator-6GHz/
├── cst/
│   ├── Ring_Resonator.cst + Ring_Resonator/   # parametric resonator model + Touchstone export
│   └── supporti/                              # 3D-printed mechanical parts
│       ├── sostegno_0.5.cst + sostegno_0.5/   # 0.5 mm spacer
│       ├── sostegno_1.cst   + sostegno_1/     # 1 mm spacer
│       ├── sostegno_2.cst   + sostegno_2/     # 2 mm spacer
│       └── vite.cst         + vite/           # fixing screw
└── docs/
    ├── Relazione Progetto TECE.pdf            # full report (in Italian)
    └── PowerPoint Progetto TECE.pptx          # presentation
```

> Each `.cst` file must stay in the same folder as its data folder of the same name, otherwise CST cannot open the project.

---

## Operating principle

The ring resonator is a **microstrip ring** coupled through a small gap to two **50 Ω feed lines**. Resonance occurs when the ring circumference is an integer multiple of the guided wavelength:

  2πr = n·λ<sub>g</sub>

A sample placed on the ring perturbs the field, which shifts the S21 peak frequency and changes its quality factor Q = f<sub>0</sub> / BW<sub>−3dB</sub>. Comparing this with the unloaded (air) response gives an estimate of the material's permittivity and losses.

## Design

- **Requirements:** f<sub>0</sub> = 6 GHz, FR-4 substrate (ε<sub>r</sub> = 4.3, 0.8 mm thick), 50 Ω lines.
- **Initial sizing:** a 1 GHz reference ring resonator was scaled by the wavelength ratio. The microstrip width (1.5 mm) was computed with Keysight ADS.
- **Parameter sweeps in CST (4–8 GHz, reference sample: 0.5 mm of air):**
  - a larger radius r lowers the resonance frequency;
  - a longer line length L shifts the peak down (6 GHz for L ≈ 50–60 mm);
  - the width W has a marginal effect (a wider board gets closer to an infinite ground plane);
  - the gap g sets the coupling: with g = 0.1 mm the S11 peak is well defined.

### Final design (`cst/Ring_Resonator`)

| Parameter | CST name | Value |
|---|---|---|
| Ring radius | `r` | 5.6 mm |
| Ground/substrate length | `length` | 52 mm |
| Ground/substrate width | `width` | 28 mm |
| Coupling gap | `g` | 0.1 mm |
| Microstrip width | `msl` | 1.5 mm |
| Substrate thickness | `d` | 0.8 mm |
| Sample (side × side × thickness) | `w_sample`, `l_sample`, `d_sample` | 14 × 14 × 0.5 mm |

Four through holes (Ø 4 mm) were added for the fixing screws, with no effect on the response. `cst/Ring_Resonator/Export/` contains a Touchstone file (`.ts`) with the S-parameters exported at 4 and 6 GHz.

## Prototyping

- Traces milled on copper-clad FR-4 with the *Milling 300*, SMA connectors soldered on.
- 0.5, 1 and 2 mm spacers and screws 3D-printed. The final assembly used threaded screws and nuts for a more stable, reproducible setup.
- 15 × 15 mm square samples of **air, FR-4, PMMA, Rogers Duroid 5870 and biosilicone**, stacked in 2 or 3 layers to vary the thickness.

## Measurements and validation

- VNA with **SOLT** calibration and de-embedding (port extension) of the 2.4 mm–SMA adapters.
- The measurements follow the CST simulations, with a **systematic offset of about +200 MHz** and 2–5 dB of extra attenuation on S21.
- The offset was derived from the air measurement and applied to all materials. The remaining mismatch in air is explained by a printed spacer slightly thicker than intended, 0.55 mm instead of 0.5 mm, as confirmed by a new simulation.
- Thin samples match the simulations well. Thicker ones still differ, because of air trapped between, and misalignment of, the stacked samples.
- Biosilicone shifts in the opposite direction (downwards). Its dielectric properties are not precisely known.

**Validation example – Duroid 5870**, obtained by tuning ε<sub>r</sub> in simulation and deriving σ from tan δ = σ / (ω ε<sub>0</sub> ε<sub>r</sub>):

| | Measured | Simulated | Deviation |
|---|---|---|---|
| ε<sub>r</sub> | 2.33 | 2.42 | ~4% |
| σ [S/m] | 1.5·10⁻⁴ | 1.48·10⁻⁴ | ~0% |

| d<sub>sample</sub> [mm] | f<sub>0</sub> [GHz] | Q sim | Q meas | ΔQ |
|---|---|---|---|---|
| 0.8 | 5.18 | 47 | 37 | 10 |
| 1.6 | 5.36 | 26.8 | 26.8 | 0 |
| 2.4 | 5.45 | 19.5 | 20.3 | 0.8 |

## Conclusions

After correcting the ~200 MHz offset derived from air, simulation and measurement agree well in peak frequency and Q factor, which confirms that the device works correctly. The ring resonator can therefore be used to estimate the dielectric properties of unknown materials, by comparing the measured response with theoretical constant-frequency and constant-Q isocurves.

---

## Requirements

- **CST Studio Suite** to open the projects in `cst/`.

> The `ModelCache/`, `Temp/` and `Result/` subfolders of the CST projects are generated by the solver and can be rebuilt by re-running the simulation.
