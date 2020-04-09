# corvid19_contagion_diffusion_forecasting_models
This project produces R code forecasting CORVID19 at the country level using Bass, Logistic and Gompertz models. The code can be amended and adapted to suit various country needs but gives working examples for the UK, Italy and Isle of Man using World of Meters data.

The R script is used in conjunction with 3 csv files, ukCorona.csv, italyCorona.csv and iomCorona.csv.  These files are mostly up to date at the time or writing. If you create your own csv data files (e.g. for other countries) be sure to build the same columns as they are all needed by the script.

To run the script, copy into R Studio. Change your country preference (find 'country <- uk' towards of script) and amend to the country of your choosing, either uk, italy or iom as country codes. Once selected and run the script will pick up the correct data file and make various amendments to code necessary to consider the differences between countries.

Models used to forecast CORVID19 diffusion: Bass, Logistic and Gompertz

Main outcome: Gompertz models look most appropriate choice for each country and produced decent forecasts. The Bass and Logistic models seem to consistently underforecast final outcome, something that needs looking at.

Work to be done. 

In-sample forecast accuracy measure (MAPE) works fine, but script needs a better data test strategy using step ahead forecast tests.  I'll get to work on this shortly. This will help give users faith in appying the models in practice.

The selection of non-linear-least_squares (NLS) start measures is rather arbitary, although functional. For the best performing model (Gompertz) each country requires its own set of starting parameters. This means you may need to find these for other countries. The Logistic model didn't show this issue and the a and b parameters can be injected into the Gompertz if needed.

A deeper review of more complex diffusion models.


