library(shiny)
# Graphics use base R to avoid additional dependencies.
app_home <- getwd()
if (!file.exists('models.R') || !file.exists('spatial_models.R')) stop('Application files missing. Extract the full ZIP and launch the folder containing app.R, models.R and spatial_models.R.')
source('models.R');source('spatial_models.R');source('advanced_models.R');source('research_extensions.R')
ui <- withMathJax(navbarPage('PhytoEpiQuant',id='main_tabs',
 header=tags$div(tags$head(tags$style(HTML("body{background:#f7fbfa;color:#254a43}.navbar-default{background:#e2f3df;border-color:#c9e5d5}.navbar-default .navbar-nav>li:nth-child(2)>a{background:#fff4d7}.navbar-default .navbar-nav>li:nth-child(3)>a{background:#e7eefb}.navbar-default .navbar-nav>li:nth-child(4)>a{background:#f4eafa}.navbar-default .navbar-nav>li:nth-child(5)>a{background:#e4f5f1}.navbar-default .navbar-nav>li:nth-child(6)>a{background:#fff1e5}.navbar-default .navbar-nav>li:nth-child(7)>a{background:#eaf1ff}.navbar-default .navbar-nav>li:nth-child(8)>a{background:#f5eafa}.navbar-default .navbar-nav>li>a{color:#285c50}.navbar-default .navbar-nav>.active>a{background:#d9eee3;color:#164b3d}.phyto-header{padding:12px 20px 10px;background:linear-gradient(105deg,#f3fbf6,#e9f5fb);border-bottom:1px solid #d4e9dd}.phyto-logo{width:min(100%,650px);max-height:130px;object-fit:contain}.brand-title{font-size:32px;font-weight:900;letter-spacing:.3px;background:linear-gradient(90deg,#087f5b,#1589ad,#7857b9,#dd8150);-webkit-background-clip:text;background-clip:text;color:transparent;margin:2px 0 3px}.author-line{font-size:14px;font-weight:800;color:#245347;margin:4px 0}.author-line a{font-weight:800;color:#146b8a;text-decoration:none}.author-line a:hover{text-decoration:underline}.result-note{background:#f2faf6;border-left:4px solid #7bbdaa;border-radius:8px;padding:12px;white-space:pre-wrap}.phyto-header p{margin:4px 0 0 8px;color:#47746c}.well{background:#f1f8f6;border:1px solid #d6e9e2;border-radius:12px}.tab-content{padding:12px}.btn-default{background:#e0f1eb;border-color:#b8dfd0;color:#205b4c}table{background:white}h3,h4{color:#1e6a57}.phyto-equation{font-size:17px;background:#fff;padding:10px;border-radius:8px;color:#184f49;overflow-x:auto}.glossary-illustration{float:right;width:170px;max-width:35%;margin:0 0 8px 16px}.concept-note{color:#446e64;font-style:italic}.shiny-plot-output{background:#fff;border:1px solid #e3eee9;border-radius:10px;padding:5px}.phyto-hero-banner{display:block;width:100%;height:auto;max-height:190px;object-fit:cover;border-radius:15px;box-shadow:0 5px 20px rgba(15,77,58,.14);margin:0 0 12px}.phyto-header{padding:16px 24px 18px!important;background:linear-gradient(120deg,#f1fbf4,#e8f5fb)!important}.phyto-workflow{display:flex;flex-wrap:wrap;gap:10px;margin-top:14px}.phyto-workflow span{padding:9px 14px;border:1px solid #bcded3;background:#fff;border-radius:10px;color:#24584e;font-weight:700;font-size:12px;box-shadow:0 2px 8px rgba(0,0,0,.04)}.navbar-default .navbar-nav>li>a{font-weight:700}.navbar-default .navbar-nav>li>a:hover{filter:brightness(.97)}@media(max-width:700px){.phyto-hero-banner{max-height:95px}.phyto-workflow span{width:100%}}"))),class='phyto-header',tags$img(src='phyto_hero_banner.jpg',class='phyto-hero-banner',alt='PhytoEpiQuant botanical disease epidemiology banner'),tags$div(class='brand-title','PhytoEpiQuant'),tags$div(class='author-line',tags$b('Dr. Manish Mathur'),' | ',tags$b('Chief Technical Officer, ARS- Net (Crop Protection), FNESA, India')),tags$div(class='author-line',tags$a(href='mailto:eco5320@gmail.com',tags$b('eco5320@gmail.com')),' | ',tags$a(href='mailto:manish.mathur@icar.org.in',tags$b('manish.mathur@icar.org.in'))),tags$div(class='phyto-workflow',tags$span('INPUT  ·  CSV / example data'),tags$span('ANALYZE  ·  Models and figures'),tags$span('INTERPRET  ·  Diagnostics and limitations'),tags$span('EXPORT  ·  Reports and results'))),

 navbarMenu('1. Fundamentals',
 tabPanel('Epidemiology glossary & equations',
  h3('Epidemiological terminology, equations and interpretation'),
  p('Educational reference adapted from the supplied Chapter 2, Attributes of Plant Epidemic. Equations are explanatory; only methods in other analytical tabs are implemented as calculators.'),
  p('Important: apparent rate r, sporulation-related basic infection rate R and basic reproduction number R0 are not interchangeable.'),
  tags$div(style='max-height:650px;overflow-y:auto;',
   tags$div(class='well',h4('Epidemic and infection cycle'),tags$img(src='glossary/concept_01.svg',class='glossary-illustration',alt='Illustration of Epidemic and infection cycle'),p('An epidemic (epiphytotic) is disease development in a host population over time. Inoculation, penetration, establishment, colonization, reproduction, dissemination and survival influence its course.'),tags$span(class='concept-note','Conceptual; no single diagnostic formula.')),
   tags$div(class='well',h4('Monocyclic / simple-interest'),tags$img(src='glossary/concept_02.svg',class='glossary-illustration',alt='Illustration of Monocyclic / simple-interest'),p('One effective infection cycle per season, typically dominated by primary inoculum. Monomolecular progress may describe saturation.'),tags$div(class='phyto-equation',HTML('\\[\\frac{dx}{dt}=QR(1-x),\\quad x(t)=1-(1-x_0)e^{-QRt}\\]'))),
   tags$div(class='well',h4('Polycyclic / compound-interest'),tags$img(src='glossary/concept_03.svg',class='glossary-illustration',alt='Illustration of Polycyclic / compound-interest'),p('Repeated secondary infection cycles in a season. Exponential early increase can become sigmoid as susceptible tissue is depleted.'),tags$div(class='phyto-equation',HTML('\\[\\frac{dx}{dt}=rx\\quad\\text{or}\\quad\\frac{dx}{dt}=rx(1-x)\\]'))),
   tags$div(class='well',h4('Mixed-cycle and polyetic epidemics'),tags$img(src='glossary/concept_04.svg',class='glossary-illustration',alt='Illustration of Mixed-cycle and polyetic epidemics'),p('Some diseases combine primary seasonal inoculum with repeated secondary spread. Polyetic epidemics build up across years, irrespective of within-season cycle count.'),tags$span(class='concept-note','Multiple-season dynamics need year-specific inoculum carryover.')),
   tags$div(class='well',h4('Incidence'),tags$img(src='glossary/concept_05.svg',class='glossary-illustration',alt='Illustration of Incidence'),p('Fraction of assessed plants or organs classified diseased. Define the unit and case criterion before counting.'),tags$div(class='phyto-equation',HTML('\\[I(\\%)=100\\frac{N_d}{N}\\]'))),
   tags$div(class='well',h4('Severity'),tags$img(src='glossary/concept_06.svg',class='glossary-illustration',alt='Illustration of Severity'),p('Proportion of host tissue area visibly affected, or a justified assessment-scale estimate; not equivalent to incidence.'),tags$div(class='phyto-equation',HTML('\\[S(\\%)=100\\frac{A_d}{A}\\]'))),
   tags$div(class='well',h4('Disease density'),tags$img(src='glossary/concept_07.svg',class='glossary-illustration',alt='Illustration of Disease density'),p('Number of lesions or infection units per specified area, plant or sampling unit.'),tags$div(class='phyto-equation',HTML('\\[D=\\frac{N_{lesions}}{A}\\]'))),
   tags$div(class='well',h4('Disease progress curve (DPC)'),tags$img(src='glossary/concept_08.svg',class='glossary-illustration',alt='Illustration of Disease progress curve (DPC)'),p('Plot of incidence or severity against time. Linear, J-shaped, sigmoid, saturation and bimodal patterns may arise; shape alone does not prove pathogen cycle type.'),tags$span(class='concept-note','Observed (time, intensity); fit candidate models only when assumptions are appropriate.')),
   tags$div(class='well',h4('Disease gradient'),tags$img(src='glossary/concept_09.svg',class='glossary-illustration',alt='Illustration of Disease gradient'),p('Change in disease intensity with distance from an inoculum source; source geometry and dispersal matter.'),tags$div(class='phyto-equation',HTML('\\[y(d)=ae^{-bd}\\]'))),
   tags$div(class='well',h4('Take-off level / zero date'),tags$img(src='glossary/concept_10.svg',class='glossary-illustration',alt='Illustration of Take-off level / zero date'),p('A selected rapid-growth threshold and its estimated crossing date; definitions are pathosystem-specific, not universal.'),tags$div(class='phyto-equation',HTML('\\[t^*=\\inf\\{t:y(t)\\geq T\\}\\]'))),
   tags$div(class='well',h4('Apparent infection rate r'),tags$img(src='glossary/concept_11.svg',class='glossary-illustration',alt='Illustration of Apparent infection rate r'),p('Rate parameter estimated from change in visible disease proportion; differs by model and observation units.'),tags$div(class='phyto-equation',HTML('\\[r=\\frac{\\operatorname{logit}(x_2)-\\operatorname{logit}(x_1)}{t_2-t_1}\\]'))),
   tags$div(class='well',h4('Basic infection rate R / reproduction number R0'),tags$img(src='glossary/concept_12.svg',class='glossary-illustration',alt='Illustration of Basic infection rate R / reproduction number R0'),p('The chapter uses R for a sporulation-related basic infection rate. R0 instead denotes secondary infections per infectious case in a fully susceptible setting. Neither equals fitted apparent r.'),tags$div(class='phyto-equation',HTML('\\[R_0>1\\]'))),
   tags$div(class='well',h4('AUDPC'),tags$img(src='glossary/concept_13.svg',class='glossary-illustration',alt='Illustration of AUDPC'),p('Trapezoidal integral of measured intensity from first to last observation. Higher values mean more cumulative measured disease over that window.'),tags$div(class='phyto-equation',HTML('\\[\\mathrm{AUDPC}=\\sum_{i=1}^{n-1}\\frac{y_i+y_{i+1}}{2}(t_{i+1}-t_i)\\]'))),
   tags$div(class='well',h4('Relative AUDPC and AUDPS'),tags$img(src='glossary/concept_14.svg',class='glossary-illustration',alt='Illustration of Relative AUDPC and AUDPS'),p('rAUDPC normalizes AUDPC to the maximum possible area; AUDPS adjusts endpoint weighting and is a distinct measure.'),tags$div(class='phyto-equation',HTML('\\[\\mathrm{rAUDPC}=\\frac{\\mathrm{AUDPC}}{100(t_n-t_1)}\\]'))),
   tags$div(class='well',h4('AUDPC limitations'),tags$img(src='glossary/concept_15.svg',class='glossary-illustration',alt='Illustration of AUDPC limitations'),p('Depends on start/end times, assessment frequency, scale, missing observations and error. Similar AUDPC may conceal very different epidemic shapes.'),tags$span(class='concept-note','Compare on matched time windows and scales; inspect original DPC.')),
   tags$div(class='well',h4('Control through x0, r and t'),tags$img(src='glossary/concept_16.svg',class='glossary-illustration',alt='Illustration of Control through x0, r and t'),p('Reducing initial inoculum, slowing epidemic rate or shortening susceptible exposure can reduce disease, with different impacts under different models.'),tags$div(class='phyto-equation',HTML('\\[x(t)\\approx x_0e^{rt}\\]'))),
   tags$div(class='well',h4('Slow / rapid epidemic and decline'),tags$img(src='glossary/concept_17.svg',class='glossary-illustration',alt='Illustration of Slow / rapid epidemic and decline'),p('Rate reflects pathogen biology, host stage and weather. Declining incidence or severity may require models allowing negative slopes or host-tissue loss.'),tags$span(class='concept-note','Model rates are descriptive; positive-only fits cannot represent declining series.')),
   tags$div(class='well',h4('Thresholds and decision making'),tags$img(src='glossary/concept_18.svg',class='glossary-illustration',alt='Illustration of Thresholds and decision making'),p('Warning, action, economic injury and epidemic thresholds have different meanings; thresholds require crop-pathogen and cost validation.'),tags$span(class='concept-note','Illustrative threshold crossing is not a fungicide recommendation.')),
   tags$div(class='well',h4('Yield loss and damage curve'),tags$img(src='glossary/concept_19.svg',class='glossary-illustration',alt='Illustration of Yield loss and damage curve'),p('Yield loss is the difference between attainable and observed yield; damage curves link measured disease to yield under a defined design.'),tags$div(class='phyto-equation',HTML('\\[L(\\%)=100\\frac{Y_a-Y_o}{Y_a}\\]'))),
   tags$div(class='well',h4('Assessment frequency'),tags$img(src='glossary/concept_20.svg',class='glossary-illustration',alt='Illustration of Assessment frequency'),p('Sampling interval influences detection of onset, rate, threshold crossing and AUDPC; time intervals need not be equal for trapezoidal integration.'),tags$span(class='concept-note','Use observed ti+1 - ti in AUDPC.')),
   tags$div(class='well',h4('Two pathogens and spillover'),tags$img(src='glossary/concept_21.svg',class='glossary-illustration',alt='Illustration of Two pathogens and spillover'),p('Co-infections may be additive, antagonistic or synergistic; spillover describes movement from a reservoir population to another host population.'),tags$div(class='phyto-equation',HTML('\\[L=\\beta_0+\\beta_1x_1+\\beta_2x_2+\\beta_{12}x_1x_2\\]'))),
   tags$div(class='well',h4('Composite fitness index (CFI)'),tags$img(src='glossary/concept_22.svg',class='glossary-illustration',alt='Illustration of Composite fitness index (CFI)'),p('Chapter 2 defines infection frequency IF, lesion area LA and sporulation capacity SC; compare only under standardized protocols.'),tags$div(class='phyto-equation',HTML('\\[\\mathrm{CFI}=IF\\times LA\\times SC\\]')))
  ),
  h4('Illustrative CFI calculator'),
  fluidRow(column(4,numericInput('edu_if','Infection frequency (0-1)',0.5,min=0,max=1,step=.05)),column(4,numericInput('edu_la','Lesion area (cm2/leaflet)',2,min=0)),column(4,numericInput('edu_sc','Sporulation capacity (sporangia/cm2)',1000,min=0))),
  verbatimTextOutput('edu_cfi'),
  p('CFI is a descriptive product, not a standardized cross-study measure without consistent experimental conditions. See the DPC and AUDPC tabs for existing analysis calculators.')
 ),
 pe_glossary_ui(),
 tabPanel('Dataset Diagnostic & Analysis Planner',
   h3('Upload once: discover suitable analyses and missing data'),
   p('Upload a CSV, inspect its quality, map your column names and see which existing PhytoEpiQuant analyses are possible. Recommendations are preliminary and do not establish model validity.'),
   fluidRow(column(5,fileInput('planner_file','Upload your dataset (.csv)',accept='.csv'),
      selectInput('planner_example','Or use a complex example',choices=c('Longitudinal disease progress'='complex_longitudinal_dpc.csv','Spatial quadrat counts'='complex_quadrat_counts.csv','Disease forecasting'='complex_disease_forecasting.csv','Disease and yield'='complex_yield_loss.csv','Disease incidence'='complex_incidence_panel.csv','Spatial grid'='complex_spatial_grid.csv')),
      radioButtons('planner_source','Data source',choices=c('Uploaded CSV'='upload','Built-in example'='example'),selected='example',inline=TRUE),textOutput('planner_source_note')),
      column(7,h4('Data overview'),verbatimTextOutput('planner_overview'))),
   h4('Preview'),tableOutput('planner_preview'),
   h4('Map your column names (optional; improves recommendations)'),
   fluidRow(column(4,selectInput('planner_time','Time / assessment day',choices=c('Not available'='')),
                   selectInput('planner_disease','Disease severity or proportion',choices=c('Not available'='')),
                   selectInput('planner_count','Disease count',choices=c('Not available'=''))),
            column(4,selectInput('planner_total','Total plants assessed',choices=c('Not available'='')),selectInput('planner_infected','Diseased plants',choices=c('Not available'='')),selectInput('planner_leaf_total','Total leaf area (cm2)',choices=c('Not available'='')),selectInput('planner_leaf_diseased','Diseased leaf area (cm2)',choices=c('Not available'='')),selectInput('planner_plot_area','Plot area (m2)',choices=c('Not available'='')),
                   selectInput('planner_x','X coordinate',choices=c('Not available'='')),
                   selectInput('planner_y','Y coordinate',choices=c('Not available'=''))),
            column(4,selectInput('planner_binary','Binary disease status (0/1)',choices=c('Not available'='')),
                   selectInput('planner_group','Treatment / replicate / site',choices=c('Not available'='')),
                   selectInput('planner_yield','Crop yield',choices=c('Not available'='')))),
   h4('Choose a single independent series for analysis'),
   uiOutput('planner_series_ui'),
   h4('Recommended analyses and missing requirements'),
   tableOutput('planner_recommendations'),h4('What your dataset can answer'),uiOutput('planner_guidance'),
   h4('Run an available analysis'),
   selectInput('planner_run_model','Select compatible analysis',choices=c('Choose after screening'='')),
   actionButton('planner_run','Use selected data and open analysis',class='btn-success'),
   textOutput('planner_transfer_status'),
   p('Ready = necessary input structure detected, not a guarantee that assumptions hold. Planned = the application does not yet provide the corresponding analysis.'),
   h4('Data-quality warnings and scientific cautions'),verbatimTextOutput('planner_warnings'),
   downloadButton('planner_report','Download suitability and requirements report (CSV)'),
   downloadButton('planner_example_download','Download selected complex example')),
 tabPanel('Data templates & column guide',
   h3('Example input files and raw-variable definitions'),
   p('Select an analysis to see the required columns, measurement scales, example values and import instructions. Download its sample CSV or the complete dictionary.'),
   selectInput('template_choice','Analysis / sub-analysis',choices=NULL),
   downloadButton('template_download','Download selected example CSV'),
   downloadButton('dictionary_download','Download complete data dictionary'),downloadButton('tab_guide_download','Download tab-to-dataset guide'),
   tableOutput('template_dictionary'),
   verbatimTextOutput('template_notes'),
   p('IMPORTANT: Some parameter CSVs and the multi-treatment AUDPC example are educational reference templates. The present application uses sidebar controls for those analyses.')),
 tabPanel('Objective–Data–Method Advisor',
   h3('Choose a research objective and match your available data to analyses'),
   p('Upload a CSV or load one of seven complex demonstration datasets. The advisor checks column availability and basic data requirements. It does not automatically establish statistical validity.'),
   selectInput('advisor_example','Complex example dataset',choices=c('Longitudinal DPC'='complex_longitudinal_dpc.csv','Incidence panel'='complex_incidence_panel.csv','Spatial disease grid'='complex_spatial_grid.csv','Quadrat counts'='complex_quadrat_counts.csv','Airborne spores'='complex_airborne_spores.csv','Time to disease'='complex_time_to_disease.csv','Yield loss'='complex_yield_loss.csv')),
   fileInput('advisor_file','Or upload your own CSV',accept='.csv'),
   selectInput('advisor_objective','Research objective',choices=c('Show all suitable analyses','Describe epidemic progression','Quantify cumulative disease','Examine count variation','Study spatial patterns','Evaluate treatment effects','Study disease onset','Assess yield loss','Describe inoculum dynamics')),
   h4('Dataset preview'),tableOutput('advisor_preview'),
   h4('Detected variables'),verbatimTextOutput('advisor_columns'),
   h4('Model suitability and availability'),tableOutput('advisor_matches'),
   h4('Prepare data for an existing calculator'),
   p('The following export is a single-series transformation only. Grouped datasets need explicit selection of one site, treatment and replicate.'),
   uiOutput('advisor_subset_ui'),
   selectInput('advisor_export','Export format',choices=c('AUDPC: time,disease (%)'='audpc','DPC: time,disease (proportion)'='dpc','Counts: diseased_count'='counts','Runs: disease_status'='runs','Coordinates: x,y'='points')),
   downloadButton('advisor_download','Download calculator-ready CSV'),
   downloadButton('advisor_registry','Download objective–method registry'),
   downloadButton('advisor_dictionary','Download complex-data dictionary'),
   downloadButton('advisor_example_download','Download selected complex example'),
   verbatimTextOutput('advisor_export_note'))
 ),
 navbarMenu('2. Disease measurement',
 tabPanel('Incidence, severity & density',
   h3('Direct disease quantification from plot-level measurements'),
   p('Use the dataset planner to transfer uploaded data, or upload a CSV here. The three indices describe different properties and must not be used interchangeably.'),
   fluidRow(column(4,fileInput('isd_file','Upload incidence, severity and density CSV',accept='.csv'),downloadButton('isd_example','Download test dataset'),downloadButton('isd_results','Download calculated results')),
            column(8,h4('Measured data and calculated indices'),tableOutput('isd_table'))),
   plotOutput('isd_plot',height='350px'),
   h4('Interpretation'),div(class='result-note',textOutput('isd_interpret')),
   withMathJax(HTML('\\[\\text{Incidence (\\%)}=100\\frac{N_{diseased}}{N_{assessed}};\\quad \\text{Severity (\\%)}=100\\frac{A_{diseased}}{A_{total}};\\quad \\text{Lesion density}=\\frac{N_{lesions}}{A_{plot}}\\]')),
   p('These are descriptive plot-level indices. Lesion density is lesions per square metre, not the fraction of plants infected. Independent replication is needed for inferential comparisons.')),
 tabPanel('Pathogen fitness (CFI)',
   h3('Composite Fitness Index: replicate-wise analysis'),p('Upload 01_CFI_replicated.csv or use the included example. CFI = infection frequency × lesion area × sporulation per area; units depend on the measurement protocol.'),
   fileInput('cfi_file','Upload CFI CSV',accept='.csv'),downloadButton('cfi_download','Download CFI results'),tableOutput('cfi_table'),plotOutput('cfi_plot',height='320px'),div(class='result-note',textOutput('cfi_note')))
 ),
 navbarMenu('3. Temporal epidemiology',
 tabPanel('DPC',sidebarLayout(sidebarPanel(selectInput('model','Growth model',c('Exponential'='exponential','Monomolecular'='monomolecular','Logistic'='logistic','Gompertz'='gompertz','Linear'='linear')),numericInput('y0','Initial proportion',.05,min=.0001,max=.999),numericInput('rate','Rate per day',.12,min=0),numericInput('duration','Days',20,min=1),fileInput('dpcfile','Observed CSV: time,disease (proportion)',accept='.csv'),downloadButton('dpcdown','Download curve')),mainPanel(plotOutput('dpcplot'),tableOutput('dpcsummary'),h4('Interpretation'),p('Exponential simulations are capped at 100% and should not be interpreted as fitted epidemic models. Disease progress models describe the temporal change in disease proportion. Simulation parameters are user-specified, not estimated from observations. Compare observed points with the curve and check model assumptions.'),div(class='result-note',textOutput('dpcinterpret')),verbatimTextOutput('dpcwarning')))),
 tabPanel('Scientific validation: DPC, AUDPC & forecasting',
   h3('Published-data validation and replicate-level epidemiology'),
   p('Upload a longitudinal dataset with time, severity_pct (0–100), treatment, moisture, replicate. Models are fitted to observed proportions on the original response scale; simulations remain in the separate DPC tab.'),
   fluidRow(column(4,fileInput('adv_file','Upload longitudinal CSV',accept='.csv'),
     actionButton('adv_example','Load published PowderyMildew example'),
     selectInput('adv_treatment','Treatment',choices=NULL),selectInput('adv_moisture','Moisture',choices=NULL),selectInput('adv_replicate','Replicate',choices=NULL),
     selectInput('adv_weighting','Fitting objective',choices=c('Unweighted Gaussian SSE (AICc descriptive)'='unweighted','Variance-weighted SSE (no comparable AICc)'='variance_weighted')),
     sliderInput('adv_boot_n','Illustrative bootstrap replicates',min=40,max=200,value=80,step=20),
     checkboxInput('adv_show_band','Show bootstrap curve band',TRUE),
     checkboxGroupInput('adv_models','Candidate models',choices=c('Logistic'='logistic','Gompertz'='gompertz','Monomolecular'='monomolecular','Exponential (bounded)'='exponential'),selected=c('logistic','gompertz','monomolecular')),
     numericInput('adv_horizon','Additional forecast days',30,min=1,max=365),
     numericInput('adv_threshold1','Early threshold (%)',20,min=0.1,max=99.9),
     numericInput('adv_threshold2','Action threshold (%)',50,min=0.1,max=99.9),
     downloadButton('adv_example_download','Download published test dataset'),
     downloadButton('adv_audpc_download','Download all replicate AUDPC'),
     downloadButton('adv_fits_download','Download model comparison'),
     downloadButton('adv_forecast_download','Download forecast and thresholds')),
     column(8,h4('Selected independent experimental series'),tableOutput('adv_preview'),
       h4('Model comparison: original-scale fitting'),p('AICc assumes independent Gaussian residuals and is descriptive only for repeated assessments. Slopes are restricted to [0,3] per day, so declining epidemics are not supported. Weighted SSE is a sensitivity analysis, not a binomial likelihood.'),tableOutput('adv_comparison'),
       plotOutput('adv_plot',height='390px'),h4('Residual diagnostics'),plotOutput('adv_residual',height='230px'),
       h4('Rolling-origin evaluation (descriptive only)'),tableOutput('adv_holdout'),
       h4('Threshold classification'),tableOutput('adv_crossings'),
       h4('Result-oriented interpretation'),div(class='result-note',textOutput('adv_interpret')))),
   h4('Replicate-wise AUDPC across the complete experiment'),tableOutput('adv_audpc_table'),
   h4('Treatment and moisture summaries'),tableOutput('adv_audpc_summary'),
   h4('Exploratory factorial treatment comparison'),verbatimTextOutput('adv_anova'),
   p('AUDPC inference assumes independently randomized experimental units. Check block design, variance assumptions and equal assessment windows. A single published experiment cannot establish out-of-study forecast validity.')),
 tabPanel('AUDPC',sidebarLayout(sidebarPanel(fileInput('audfile','CSV: time,disease (percent)',accept='.csv'),helpText('Built-in example: days 0,5,10,15,20; severity 5,12,25,40,60.'),downloadButton('auddown','Download AUDPC')),mainPanel(tableOutput('audtable'),verbatimTextOutput('audresult'),plotOutput('audplot'),div(class='result-note',textOutput('audinterpret')),h4('Interpretation'),p('AUDPC is integrated from the FIRST observed assessment to the LAST, not necessarily from day zero. AUDPC integrates disease severity across time; rAUDPC scales by the maximum possible area over the observed period. Compare groups only on comparable observation intervals and measurement scales.')))),
 tabPanel('Polyetic epidemics',
   h3('Between-season epidemic patterns'),p('Descriptive seasonal relationships; six observations cannot establish mechanistic inoculum carryover.'),
   fileInput('poly_file','Upload 06_Polyetic_seasons.csv',accept='.csv'),downloadButton('poly_download','Download seasonal results'),tableOutput('poly_table'),plotOutput('poly_plot',height='340px'),div(class='result-note',textOutput('poly_note')))
 ),
 navbarMenu('4. Statistical epidemiology',
 tabPanel('Probability distributions',sidebarLayout(sidebarPanel(
   fileInput('probfile','Upload observations CSV',accept='.csv'),selectInput('probexample','Or load a demonstration dataset',c('Count observations'='probability_counts.csv','Binomial observations'='probability_binomial.csv','Proportions'='probability_proportions.csv','Continuous positive measurements'='probability_positive.csv')),
   selectInput('probcol','Observed variable',choices=NULL),selectInput('dist','Distribution',c('Poisson','Negative binomial','Binomial','Normal','Exponential','Beta','Gamma','Beta-binomial')),
   radioButtons('probmode','Parameters',c('Estimate from uploaded/example data'='estimate','Enter manually'='manual')),
   numericInput('p1','Parameter 1 (lambda / mean / alpha)',2),numericInput('p2','Parameter 2 (probability / SD / beta)',.4),numericInput('p3','Parameter 3 (size / beta / n)',5),
   helpText('For binomial and beta-binomial, upload successes and trials columns. For beta, values must lie strictly between 0 and 1.'),
   downloadButton('probexampledown','Download example CSV'),downloadButton('probdn','Download fitted probabilities')),
   mainPanel(h4('Uploaded data preview'),tableOutput('probpreview'),h4('Parameter estimates'),tableOutput('probparams'),plotOutput('probplot',height='380px'),h4('Model interpretation'),verbatimTextOutput('probinterpret'),tableOutput('probtable')))),
 tabPanel('Count distributions',sidebarLayout(sidebarPanel(textAreaInput('counts','Diseased counts by sampling unit','2,3,3,8,9'),fileInput('countsfile','Or upload count_distributions.csv',accept='.csv'),downloadButton('countdown','Download count comparison')),mainPanel(tableOutput('counttable'),plotOutput('countplot'),div(class='result-note',textOutput('countinterpret')),h4('Interpretation'),p('Compare observed disease-count frequencies with Poisson and negative-binomial expectations. Overdispersion suggests heterogeneous or aggregated counts; model adequacy requires additional diagnostics.')))),
 tabPanel('Dispersion',sidebarLayout(sidebarPanel(textAreaInput('dispcounts','Diseased counts','2,3,3,8,9'),fileInput('dispfile','Or upload dispersion.csv',accept='.csv'),downloadButton('dispdown','Download statistics')),mainPanel(tableOutput('disptable'),div(class='result-note',textOutput('dispinterpret')),p('D > 1 indicates overdispersion relative to a Poisson benchmark. The chi-square approximation assumes independent, identically distributed sampling units.')))),
 tabPanel('Runs test',sidebarLayout(sidebarPanel(textAreaInput('binary','Ordered disease sequence, 1 diseased, 0 healthy','1,1,0,0,1,0,1,1,0'),fileInput('runsfile','Or upload runs.csv',accept='.csv'),downloadButton('runsdown','Download runs result')),mainPanel(tableOutput('runstable'),div(class='result-note',textOutput('runsinterpret')),h4('Interpretation'),p('Runs quantify clustering along an ordered transect. Fewer runs than expected can indicate clustering, subject to sampling design and test assumptions.'),p('The normal-approximation p-value can be inaccurate for short sequences.'))))
 ),
 navbarMenu('5. Spatial epidemiology',
 tabPanel('Disease gradient',
   h3('Disease severity across distance'),p('Descriptive distance-decay analysis; inference requires replicated transects and spatial sampling design.'),
   fileInput('grad_file','Upload 07_Pathogen_gradient.csv',accept='.csv'),downloadButton('grad_download','Download gradient results'),tableOutput('grad_table'),plotOutput('grad_plot',height='340px'),div(class='result-note',textOutput('grad_note'))),
 tabPanel('Nearest neighbour',sidebarLayout(sidebarPanel(fileInput('points','CSV: x,y',accept='.csv'),numericInput('area','Study window area in squared coordinate units',100,min=.001),downloadButton('nndown','Download NN statistics')),mainPanel(tableOutput('nntable'),plotOutput('nnplot'),div(class='result-note',textOutput('nninterpret')),h4('Interpretation'),p('Clark–Evans R below 1 suggests clustered points relative to complete spatial randomness; above 1 suggests more regular spacing. Edge effects are not corrected.'),p('Descriptive Clark–Evans ratio only; no boundary correction or hypothesis test. Edge effects can bias R, especially for small samples. Coordinates must use planar distance units.')))),
 tabPanel('Directed network',sidebarLayout(sidebarPanel(fileInput('network','CSV adjacency matrix (no header)',accept='.csv'),downloadButton('netdown','Download network metrics')),mainPanel(tableOutput('nettable'),div(class='result-note',textOutput('netinterpret')),h4('Interpretation'),p('In-degree counts incoming links and out-degree counts outgoing links; connectance measures the fraction of possible directed links present.'),p('Rows are source nodes; columns are destination nodes. Directed binary graph with no self-loops.'))))
 ),
 navbarMenu('6. Advanced analysis',
 tabPanel('Venn diagram & method overlap',sidebarLayout(sidebarPanel(
   h4('Upload dataset capability table'),fileInput('vennfile','CSV with dataset_id and four binary capability columns',accept='.csv'),
   helpText('One row per dataset. Required: dataset_id plus 1–12 binary (0/1) category columns. Two to four categories produce a proportional-count Venn; more use exact intersections.'),
   downloadButton('vennexample','Download complex example (160 datasets)'),downloadButton('vennresults','Download overlap counts'),
   radioButtons('vennmode','Visualization',c('Exact intersection chart (recommended for 5+ categories)'='upset','Adaptive 2–4 circle Venn (requires VennDiagram)'='venn'),selected='venn'),
   h4('Uploaded data preview'),tableOutput('vennpreview')),
   mainPanel(h3('Dataset capability overlap'),p('Counts describe datasets having multiple data capabilities, not biological overlap or statistical significance.'),
   plotOutput('vennplot',height='440px',width='100%'),h4('Exact intersections'),tableOutput('venntable'),h4('Interpretation'),verbatimTextOutput('venninterpret')))),
 tabPanel('Two pathogens & yield',
   h3('Two-pathogen disease burden and yield'),p('Exploratory associations only; six plots do not provide robust estimates of interaction effects or causal yield loss.'),
   fileInput('two_file','Upload 08_Two_pathogen_yield.csv',accept='.csv'),downloadButton('two_download','Download plot-level results'),tableOutput('two_table'),plotOutput('two_plot',height='340px'),div(class='result-note',textOutput('two_note'))),
 pe_niche_ui()
 ),
 navbarMenu('7. Prediction',
 tabPanel('Disease forecasting & thresholds',sidebarLayout(sidebarPanel(
   fileInput('forecastfile','Upload time-series CSV: time,disease (%) and optional site,treatment,replicate',accept='.csv'),
   selectInput('forecastexample','Example dataset',c('Simple single-series'='forecast_disease.csv','Complex 3-site treatment study (396 rows)'='complex_disease_forecasting.csv')),
   uiOutput('forecastgroups'),
   selectInput('forecastmodel','Forecast curve',c('Logistic'='logistic','Gompertz'='gompertz','Monomolecular'='monomolecular')),
   numericInput('forecastdays','Forecast horizon (days)',60,min=1,max=1000),
   numericInput('threshold1','Early warning threshold (%)',20,min=0.1,max=99.9),
   numericInput('threshold2','Action threshold (%)',50,min=0.1,max=99.9),
   downloadButton('forecast_example_download','Download selected example CSV'),downloadButton('forecastdown','Download forecast CSV'),downloadButton('forecast_dictionary','Download column guide')),
   mainPanel(h4('Selected time series preview'),tableOutput('forecastpreview'),plotOutput('forecastplot',height='400px'),h4('Estimated threshold crossings'),tableOutput('forecasttable'),h4('Interpretation and cautions'),verbatimTextOutput('forecastinterpret'),h4('Crop-protection decision guidance'),div(class='result-note',uiOutput('forecast_advice')))))
 ),
 navbarMenu('8. Integrated reporting',
 pe_multi_ui()
 )
))
server <- function(input,output,session){


 observeEvent(input$planner_file,{if(!is.null(input$planner_file))updateRadioButtons(session,'planner_source',selected='upload')})
 output$planner_source_note <- renderText({if(identical(input$planner_source,'upload')){if(is.null(input$planner_file))'Select a CSV file to analyse.' else paste('Analysing uploaded file:',input$planner_file$name)} else paste('Analysing built-in example:',input$planner_example)})
 planner_data <- reactive({
   if (identical(input$planner_source,'upload') && !is.null(input$planner_file)) {
     tryCatch(read.csv(input$planner_file$datapath,check.names=FALSE),error=function(e) NULL)
   } else if (identical(input$planner_source,'upload')) { return(NULL) } else {
     path <- file.path('examples',input$planner_example)
     if(file.exists(path)) tryCatch(read.csv(path,check.names=FALSE),error=function(e) NULL) else NULL
   }
 })
 observeEvent(planner_data(),{
   d<-planner_data();req(d); nm<-names(d)
   aliases<-list(planner_infected=c('plants_diseased','diseased_plants','infected_plants'),planner_leaf_total=c('total_leaf_area_cm2','total_leaf_area'),planner_leaf_diseased=c('diseased_leaf_area_cm2','infected_leaf_area_cm2'),planner_plot_area=c('plot_area_m2','area_m2'),planner_time=c('time','day','days','days_after_planting','assessment_day'),planner_disease=c('severity_pct','disease_proportion','disease','incidence_pct','severity','incidence'),planner_count=c('diseased_count','count','spore_count','lesions_count','lesion_count'),planner_total=c('total_plants','plants_assessed','n_plants'),planner_x=c('x','x_m','longitude'),planner_y=c('y','y_m','latitude'),planner_binary=c('disease_status','infected','status'),planner_group=c('treatment','replicate','site','field_id','season','year'),planner_yield=c('yield_kg_plot','yield','yield_kg'))
   for(id in names(aliases)){
     hit<-nm[tolower(nm)%in%aliases[[id]]]
     updateSelectInput(session,id,choices=c('Not available'='',stats::setNames(nm,nm)),selected=if(length(hit))hit[1] else '')
   }
 })
 output$planner_preview<-renderTable({d<-planner_data();req(d);head(d,8)},striped=TRUE)
 output$planner_overview<-renderText({d<-planner_data();req(d);paste('Rows:',nrow(d),' | Columns:',ncol(d),' | Missing cells:',sum(is.na(d)),' | Duplicated rows:',sum(duplicated(d)),'\nColumns:',paste(names(d),collapse=', '))})
 planner_assess<-reactive({
   d<-planner_data();req(d)
   getcol<-function(id){nm<-input[[id]];if(is.null(nm)||!nzchar(nm)||!nm%in%names(d))return(NULL);d[[nm]]}
   t<-getcol('planner_time');dis<-getcol('planner_disease');ct<-getcol('planner_count');total<-getcol('planner_total');infected<-getcol('planner_infected');leaf_total<-getcol('planner_leaf_total');leaf_diseased<-getcol('planner_leaf_diseased');plot_area<-getcol('planner_plot_area');x<-getcol('planner_x');y<-getcol('planner_y');bin<-getcol('planner_binary');grp<-getcol('planner_group');yield<-getcol('planner_yield')
   numeric_ok<-function(v) !is.null(v)&&is.numeric(v)&&sum(is.finite(v))>=2
   count_ok<-function(v) numeric_ok(v)&&all(v[is.finite(v)]>=0 & v[is.finite(v)]==floor(v[is.finite(v)]))
   binary_ok<-function(v) !is.null(v)&&all(stats::na.omit(v)%in%c(0,1))&&length(stats::na.omit(v))>=3
   time_ok<-numeric_ok(t)&&length(unique(t[is.finite(t)]))>=2
   disease_ok<-numeric_ok(dis)&&all(dis[is.finite(dis)]>=0 & dis[is.finite(dis)]<=100)
   specs<-list(
    list('Disease progress curve (DPC)',time_ok&&disease_ok,'Numeric time and disease values (0–1 or 0–100)','Implemented: simulation and overlay; original-scale fitting in Scientific validation tab','Select one independent series; DPC fitting is not implemented'),
    list('AUDPC / relative AUDPC',time_ok&&disease_ok,'At least two unique assessment times and disease percentage','Implemented','Convert proportions to percentages; compare equal time windows'),
    list('Poisson / negative-binomial counts',count_ok(ct),'Nonnegative integer counts per sampling unit','Implemented','Sampling units should be comparable'),
    list('Dispersion index',count_ok(ct),'At least two nonnegative integer counts','Implemented','Overdispersion does not prove spatial clustering'),
    list('Runs analysis',binary_ok(bin),'Ordered binary 0/1 disease sequence','Implemented','Rows must preserve the sampling/transect order'),
    list('Nearest neighbour',numeric_ok(x)&&numeric_ok(y),'Projected planar x/y coordinates and study-window area','Implemented','Longitude/latitude must be projected; boundary correction absent'),
    list('Incidence, severity & lesion density',numeric_ok(total)&&count_ok(infected)&&numeric_ok(leaf_total)&&numeric_ok(leaf_diseased)&&count_ok(ct)&&numeric_ok(plot_area),'Plants assessed, plants diseased, total and diseased leaf areas, lesion count and plot area','Implemented: direct calculator','Denominators must be positive; numerator must not exceed denominator'),
    list('Treatment comparison',time_ok&&disease_ok&&!is.null(grp),'Time, disease, treatment and independent replicates','Planned','Replicate IDs and experimental design needed'),
    list('Yield-loss regression',numeric_ok(yield)&&disease_ok,'Yield and disease severity per experimental unit','Planned','Confounding and design require assessment'),
    list('Disease threshold forecasting',time_ok&&disease_ok,'At least 4 distinct time points, time and disease (%)','Implemented: exploratory','Validate predictions; extrapolation is uncertain'))
   do.call(rbind,lapply(specs,function(z){ready<-isTRUE(z[[2]]);data.frame(Analysis=z[[1]],Input_status=if(ready)'Inputs detected' else 'Needs data or mapping',Required_data=z[[3]],Application_status=z[[4]],Scientific_note=z[[5]],check.names=FALSE)}))
 })

 output$planner_guidance <- renderUI({
   d<-planner_data();req(d)
   nms<-tolower(names(d)); rec<-planner_assess()
   available<-rec$Analysis[rec$Input_status=='Inputs detected']
   missing<-rec$Analysis[rec$Input_status!='Inputs detected']
   polyetic<-any(grepl('season|year',nms))
   tags$div(class='result-note',
     tags$p(tags$b('Detected candidate analyses: '),if(length(available))paste(available,collapse='; ') else 'No existing model has sufficient mapped variables yet.'),
     tags$p(tags$b('Other methods need additional columns or mapping: '),paste(missing,collapse='; ')),
     if(polyetic) tags$p(tags$b('Multi-season dataset detected. '),'If disease severity and assessment time are available, analyse each season and replicate separately. Cross-season carryover and polyetic effects require a dedicated longitudinal model; they are not automatically estimated by the existing DPC tab.'),
     tags$p('Use the compatibility table above to check exact missing variables. A detected input is not proof that model assumptions or sample size are adequate.')
   )
 })
 output$planner_recommendations<-renderTable(planner_assess(),striped=TRUE,spacing='xs')

 output$planner_series_ui <- renderUI({
   d<-planner_data();req(d)
   keys<-intersect(c('site','station','field_id','treatment','replicate','plot_id'),names(d))
   if(!length(keys)) return(helpText('No grouping columns detected. All observations will be used.'))
   tagList(lapply(keys,function(k)selectInput(paste0('planner_filter_',k),paste('Select',k),choices=unique(as.character(d[[k]])),selected=as.character(d[[k]][1]))))
 })
 planner_series <- reactive({
   d<-planner_data();req(d)
   for(k in intersect(c('site','station','field_id','treatment','replicate','plot_id'),names(d))){
     v<-input[[paste0('planner_filter_',k)]]
     if(!is.null(v)&&nzchar(v)) d<-d[as.character(d[[k]])==v,,drop=FALSE]
   }
   d
 })
 observeEvent(planner_assess(),{
   z<-planner_assess()
   choices<-setNames(z$Analysis[z$Input_status=='Inputs detected' & grepl('Implemented',z$Application_status)],z$Analysis[z$Input_status=='Inputs detected' & grepl('Implemented',z$Application_status)])
   updateSelectInput(session,'planner_run_model',choices=c('Select an analysis'='',choices))
 })
 transfer <- reactiveVal(NULL)
 observeEvent(input$planner_run,{
   req(nzchar(input$planner_run_model))
   d<-planner_series();req(nrow(d)>0)
   getmap<-function(key){z<-input[[key]];if(is.null(z)||!nzchar(z)||!z%in%names(d))NULL else d[[z]]}
   analysis<-input$planner_run_model
   target<-switch(analysis,
     'Disease progress curve (DPC)'='DPC',
     'AUDPC / relative AUDPC'='AUDPC',
     'Poisson / negative-binomial counts'='Count distributions',
     'Dispersion index'='Dispersion',
     'Runs analysis'='Runs test',
     'Nearest neighbour'='Nearest neighbour',
     'Disease threshold forecasting'='Disease forecasting & thresholds',
     'Incidence, severity & lesion density'='Incidence, severity & density',
     NULL)
   if(is.null(target)){showNotification('This analysis has no direct calculator yet.',type='warning');return()}
   if(target=='Incidence, severity & density'){
     d<-data.frame(plot=if('plot'%in%names(d))as.character(d$plot) else paste0('P',seq_len(nrow(d))),plants_assessed=as.numeric(getmap('planner_total')),plants_diseased=as.numeric(getmap('planner_infected')),total_leaf_area_cm2=as.numeric(getmap('planner_leaf_total')),diseased_leaf_area_cm2=as.numeric(getmap('planner_leaf_diseased')),lesions_count=as.numeric(getmap('planner_count')),plot_area_m2=as.numeric(getmap('planner_plot_area')))
   } else if(target%in%c('DPC','AUDPC','Disease forecasting & thresholds')){
     t<-getmap('planner_time'); y<-getmap('planner_disease')
     if(is.null(t)||is.null(y)){showNotification('Map time and disease first.',type='error');return()}
     if(any(!is.finite(as.numeric(t)))||any(!is.finite(as.numeric(y)))){showNotification('Selected time series contains missing/non-numeric values.',type='error');return()}
     if(length(unique(t))<2 || anyDuplicated(t)){showNotification('Select a single series with distinct assessment times.',type='error');return()}
     y<-as.numeric(y); if(max(y,na.rm=TRUE)<=1) y<-y*100
     if(any(y<0|y>100)){showNotification('Disease must be in 0-100% range.',type='error');return()}
     d<-data.frame(time=as.numeric(t),disease=y)
   } else if(target%in%c('Count distributions','Dispersion')){
     v<-getmap('planner_count');req(!is.null(v));d<-data.frame(diseased_count=as.numeric(v))
   } else if(target=='Runs test'){
     v<-getmap('planner_binary');req(!is.null(v));d<-data.frame(disease_status=as.numeric(v))
   } else if(target=='Nearest neighbour'){
     x<-getmap('planner_x');y<-getmap('planner_y');req(!is.null(x),!is.null(y))
     if(any(grepl('lon|lat',c(input$planner_x,input$planner_y),ignore.case=TRUE))){showNotification('Project longitude/latitude to planar coordinates before nearest-neighbour analysis.',type='error');return()}
     d<-data.frame(x=as.numeric(x),y=as.numeric(y))
   }
   transfer(list(target=target,data=d))
   updateTabsetPanel(session,'main_tabs',selected=target)
   showNotification(paste('Prepared',nrow(d),'rows for',target,'using the shared planner data.'),type='message',duration=8)
 })
 output$planner_transfer_status<-renderText({x<-transfer();if(is.null(x))return('');paste('Prepared',nrow(x$data),'observations for',x$target,'. The destination tab uses this dataset until its own CSV is uploaded.')})
 shared_for <- function(tab){x<-transfer();if(is.null(x)||!identical(x$target,tab))return(NULL);x$data}

 isd_data <- reactive({
   if(!is.null(input$isd_file)) return(tryCatch(read.csv(input$isd_file$datapath,check.names=FALSE),error=function(e)NULL))
   x<-shared_for('Incidence, severity & density')
   if(!is.null(x))return(x)
   read.csv(file.path('examples','04_Incidence_severity_density.csv'))
 })
 isd_calc <- reactive({
   d<-isd_data();req(d)
   required<-c('plants_assessed','plants_diseased','total_leaf_area_cm2','diseased_leaf_area_cm2','lesions_count','plot_area_m2')
   validate(need(all(required%in%names(d)),paste('Missing columns:',paste(setdiff(required,names(d)),collapse=', '))))
   for(k in required)d[[k]]<-suppressWarnings(as.numeric(d[[k]]))
   validate(need(all(is.finite(as.matrix(d[required]))),'All six measurement columns must contain finite numeric values.'),need(all(d$plants_assessed>0 & d$total_leaf_area_cm2>0 & d$plot_area_m2>0),'Denominators must be greater than zero.'),need(all(d$plants_diseased>=0 & d$plants_diseased<=d$plants_assessed & d$diseased_leaf_area_cm2>=0 & d$diseased_leaf_area_cm2<=d$total_leaf_area_cm2 & d$lesions_count>=0),'Counts and areas must be nonnegative, and diseased values cannot exceed totals.'))
   d$incidence_pct<-round(100*d$plants_diseased/d$plants_assessed,4)
   d$severity_pct<-round(100*d$diseased_leaf_area_cm2/d$total_leaf_area_cm2,4)
   d$lesion_density_m2<-round(d$lesions_count/d$plot_area_m2,4)
   d
 })
 output$isd_table<-renderTable(isd_calc(),striped=TRUE)
 output$isd_plot<-renderPlot({
   d<-isd_calc();n<-nrow(d);labels<-if('plot'%in%names(d))as.character(d$plot) else paste0('P',seq_len(n))
   old<-par(mfrow=c(1,3),mar=c(5,4,3,1));on.exit(par(old))
   for(z in list(list('incidence_pct','Incidence (%)','#7bbcb1'),list('severity_pct','Severity (%)','#8ba9dd'),list('lesion_density_m2','Lesions / m2','#e9b681'))){barplot(d[[z[[1]]]],names.arg=labels,col=z[[3]],main=z[[2]],ylab=z[[2]],las=2)}
 })
 output$isd_interpret<-renderText({d<-isd_calc();paste0('Across ',nrow(d),' plot(s), disease incidence ranged from ',min(d$incidence_pct),'% to ',max(d$incidence_pct),'%; severity from ',min(d$severity_pct),'% to ',max(d$severity_pct),'%; and lesion density from ',min(d$lesion_density_m2),' to ',max(d$lesion_density_m2),' lesions/m2. Incidence describes affected plants, severity describes affected leaf area, and density describes lesion abundance per unit plot area. These indices are not directly comparable as magnitudes. With ',nrow(d),' plots, results are descriptive; do not infer statistical treatment effects without an appropriate replicated design.')})
 output$isd_example<-downloadHandler(filename=function()'04_Incidence_severity_density.csv',content=function(file)file.copy(file.path('examples','04_Incidence_severity_density.csv'),file))
 output$isd_results<-downloadHandler(filename=function()'PhytoEpiQuant_incidence_severity_density_results.csv',content=function(file)write.csv(isd_calc(),file,row.names=FALSE))
 output$planner_warnings<-renderText({
   d<-planner_data();req(d); notes<-character()
   if(anyNA(d))notes<-c(notes,paste('Missing values:',sum(is.na(d)),'cells. Review missingness by variable.'))
   if(any(duplicated(d)))notes<-c(notes,paste('Duplicate rows:',sum(duplicated(d)),'. Confirm whether these are valid repeat measurements.'))
   if(nrow(d)<10)notes<-c(notes,'Small dataset: many distribution fits and tests may be unreliable.')
   if(!is.null(input$planner_disease)&&nzchar(input$planner_disease)&&input$planner_disease%in%names(d)){
     v<-d[[input$planner_disease]];if(is.numeric(v)&&any(v>1,na.rm=TRUE)&&all(v<=100,na.rm=TRUE))notes<-c(notes,'Disease variable appears to be percentage (0–100). DPC uses proportions (0–1); AUDPC uses percentages.')
   }
   if(!length(notes))notes<-'No obvious structural warnings. Check biological definitions, study design, independence, missingness mechanisms and model assumptions before analysis.'
   paste(notes,collapse='\n')
 })
 output$planner_report<-downloadHandler(filename=function()'PhytoEpiQuant_analysis_suitability.csv',content=function(file)write.csv(planner_assess(),file,row.names=FALSE))
 output$planner_example_download<-downloadHandler(filename=function()input$planner_example,content=function(file)file.copy(file.path('examples',input$planner_example),file))

 output$tab_guide_download <- downloadHandler(function()'TAB_DATASET_GUIDE.csv',function(f)file.copy('TAB_DATASET_GUIDE.csv',f,overwrite=TRUE))

 method_registry <- read.csv('MODEL_OBJECTIVE_REGISTRY.csv',stringsAsFactors=FALSE,check.names=FALSE)
 advisor_data <- reactive({
   if(is.null(input$advisor_file)) d <- read.csv(file.path('examples',input$advisor_example),check.names=FALSE)
   else d <- read.csv(input$advisor_file$datapath,check.names=FALSE)
   validate(need(nrow(d)>0,'Dataset must have at least one row'),need(ncol(d)>0,'Dataset must have at least one column'))
   d
 })
 output$advisor_preview <- renderTable(head(advisor_data(),8),striped=TRUE)
 output$advisor_columns <- renderText({d<-advisor_data();paste('Rows:',nrow(d),'| Columns:',ncol(d),'\n',paste(names(d),collapse=', '))})
 objective_terms <- c('Describe epidemic progression'='DPC|progress','Quantify cumulative disease'='AUDPC','Examine count variation'='count|dispersion|Poisson','Study spatial patterns'='spatial|nearest|runs','Evaluate treatment effects'='treatment','Study disease onset'='Survival','Assess yield loss'='yield','Describe inoculum dynamics'='inoculum')
 advisor_match <- reactive({
   d<-advisor_data(); reg<-method_registry
   status<-vapply(seq_len(nrow(reg)),function(i){
     needed<-trimws(strsplit(reg$required_columns[i],',',fixed=TRUE)[[1]])
     needed<-needed[nzchar(needed)]
     if(length(needed)==0)return('Parameter-based: no columns needed')
     if(!all(needed %in% names(d)))return(paste('Missing:',paste(setdiff(needed,names(d)),collapse=', ')))
     if(nrow(d)<2)return('Insufficient rows')
     if('time' %in% needed && length(unique(d$time))<2)return('Need at least two observation times')
     if('diseased_count' %in% needed && (anyNA(d$diseased_count)||any(d$diseased_count<0)||any(d$diseased_count!=floor(d$diseased_count))))return('Counts must be nonnegative integers')
     if('disease_status' %in% needed && !all(d$disease_status %in% c(0,1)))return('Status must be binary 0/1')
     if('severity_pct' %in% needed && (anyNA(d$severity_pct)||any(d$severity_pct<0|d$severity_pct>100)))return('Severity must be 0–100')
     if('disease_proportion' %in% needed && (anyNA(d$disease_proportion)||any(d$disease_proportion<0|d$disease_proportion>1)))return('Proportions must be 0–1')
     if('plants_diseased' %in% needed && 'plants_assessed' %in% names(d) && any(d$plants_diseased>d$plants_assessed))return('Diseased count exceeds assessed')
     'Columns and basic values compatible'
   },character(1))
   reg$dataset_check<-status
   obj<-input$advisor_objective
   if(!is.null(obj)&&obj!='Show all suitable analyses'){
     pattern<-objective_terms[[obj]]
     reg<-reg[grepl(pattern,paste(reg$method,reg$objective),ignore.case=TRUE),,drop=FALSE]
   }
   reg[,c('method','availability','dataset_check','limitations','minimum_conditions')]
 })
 output$advisor_matches <- renderTable(advisor_match(),striped=TRUE,spacing='xs')
 output$advisor_subset_ui <- renderUI({
   d<-advisor_data(); keys<-intersect(c('site','field_id','treatment','replicate','station'),names(d))
   lapply(keys,function(k)selectInput(paste0('subset_',k),paste('Select',k),choices=c('Choose one'= '',as.character(unique(d[[k]])))))
 })
 advisor_subset <- reactive({
   d<-advisor_data()
   for(k in intersect(c('site','field_id','treatment','replicate','station'),names(d))){
     v<-input[[paste0('subset_',k)]]
     validate(need(!is.null(v)&&nzchar(v),paste('Select a single',k,'before exporting; do not mix groups')))
     d<-d[as.character(d[[k]])==v,,drop=FALSE]
   }
   d
 })
 advisor_export_data <- reactive({
   d<-advisor_subset();fmt<-input$advisor_export
   if(fmt %in% c('audpc','dpc')){
     validate(need('time' %in% names(d),'Missing time column'))
     target<-if(fmt=='audpc') 'severity_pct' else 'disease_proportion'
     if(!target %in% names(d)){
       if(fmt=='audpc' && 'disease_proportion' %in% names(d))d$severity_pct<-100*d$disease_proportion
       else if(fmt=='dpc' && 'severity_pct' %in% names(d))d$disease_proportion<-d$severity_pct/100
       else validate(need(FALSE,paste('Missing',target)))
     }
     validate(need(!anyDuplicated(d$time),'Duplicate time values: select one observation series'))
     d<-d[order(d$time),,drop=FALSE]
     validate(need(nrow(d)>=2,'Need at least two time points'))
     z<-data.frame(time=d$time,disease=d[[target]])
     validate(need(all(is.finite(z$disease)),'Disease must be numeric and finite'))
     return(z)
   }
   if(fmt=='counts'){
     validate(need('diseased_count' %in% names(d),'Missing diseased_count'))
     return(data.frame(diseased_count=d$diseased_count))
   }
   if(fmt=='runs'){
     validate(need('disease_status' %in% names(d),'Missing disease_status'))
     validate(need(all(d$disease_status %in% c(0,1)),'Disease status must be 0 or 1'))
     if(all(c('row','column') %in% names(d)))d<-d[order(d$row,d$column),,drop=FALSE]
     return(data.frame(disease_status=d$disease_status))
   }
   validate(need(all(c('x_m','y_m') %in% names(d)),'Missing x_m,y_m'))
   data.frame(x=d$x_m,y=d$y_m)
 })
 output$advisor_export_note <- renderText({paste('Exports prepare input for the existing calculator only. They do not automatically run statistical inference. For nearest-neighbour analysis, manually provide the correct study-window area. For runs analysis, confirm the ordering represents your sampling transect.')})
 output$advisor_download <- downloadHandler(function()paste0('prepared_',input$advisor_export,'.csv'),function(file)write.csv(advisor_export_data(),file,row.names=FALSE))
 output$advisor_registry <- downloadHandler(function()'MODEL_OBJECTIVE_REGISTRY.csv',function(file)file.copy('MODEL_OBJECTIVE_REGISTRY.csv',file,overwrite=TRUE))
 output$advisor_dictionary <- downloadHandler(function()'COMPLEX_DATA_DICTIONARY.csv',function(file)file.copy('COMPLEX_DATA_DICTIONARY.csv',file,overwrite=TRUE))
 output$advisor_example_download <- downloadHandler(function()input$advisor_example,function(file)file.copy(file.path('examples',input$advisor_example),file,overwrite=TRUE))
 dictionary <- read.csv('DATA_DICTIONARY.csv',check.names=FALSE,stringsAsFactors=FALSE)
 template_files <- unique(dictionary[['Example file']])
 updateSelectInput(session,'template_choice',choices=template_files,selected=template_files[1])
 template_row <- reactive({req(input$template_choice);dictionary[dictionary[['Example file']]==input$template_choice,,drop=FALSE]})
 output$template_dictionary <- renderTable(template_row()[,c('Column name','Meaning','Unit / scale','Allowed values','Example value')],striped=TRUE)
 output$template_notes <- renderText({d<-template_row();paste('Tab:',d$Tab[1],'\nSub-analysis:',d[['Sub-analysis']][1],'\nInstructions:',d[['Preparation / import instructions']][1],'\nExample:',d[['Worked example']][1],'\nDirect CSV upload supported:',d[['Direct CSV upload supported']][1])})
 output$template_download <- downloadHandler(filename=function()input$template_choice,content=function(file)file.copy(file.path('examples',input$template_choice),file,overwrite=TRUE))
 output$dictionary_download <- downloadHandler(filename=function()'PhytoEpiQuant_Data_Dictionary.csv',content=function(file)file.copy('DATA_DICTIONARY.csv',file,overwrite=TRUE))

 output$catalog<-renderTable(data.frame(Analysis=c('DPC','AUDPC','Count distribution','Dispersion','Runs','Nearest neighbour','Directed network','Probability distributions'),Example=c('y0=.05, r=.12, 20 days','547.5 percent-days','2,3,3,8,9','D=2.1','9 binary observations','5 planar points','4-node directed graph','Poisson(lambda=2)')))
 numbers<-function(s){x<-suppressWarnings(as.numeric(trimws(strsplit(s,',',fixed=TRUE)[[1]])));validate(need(length(x)>1&&all(is.finite(x)),'Provide at least two valid comma-separated numbers'));x}
 read_example<-function(upload,name){if(is.null(upload))return(read.csv(file.path('examples',name)));read.csv(upload$datapath,check.names=FALSE)}
 curve<-reactive({t<-seq(0,input$duration,length.out=101);data.frame(time=t,predicted=phyto_curve(t,input$y0,input$rate,input$model))})
 output$dpcplot<-renderPlot({d<-curve();plot(d$time,d$predicted,type='l',lwd=3,col='#238a78',xlab='Days',ylab='Disease proportion',ylim=range(c(0,1,d$predicted)),main='Disease progress curve');abline(h=1,lty=2,col='gray');if(!is.null(input$dpcfile)||!is.null(shared_for('DPC'))){o<-if(!is.null(input$dpcfile))read.csv(input$dpcfile$datapath) else transform(shared_for('DPC'),disease=disease/100);validate(need(all(c('time','disease')%in%names(o)),'Required columns: time,disease'));points(o$time,o$disease,pch=19,col='#e98271')}})
 output$dpcsummary<-renderTable(tail(curve(),1),digits=4)
 output$dpcwarning<-renderText(if(any(curve()$predicted>1))'WARNING: predicted proportion exceeds 1; exponential/linear extrapolation is biologically invalid beyond this point.' else 'All displayed predictions are within 0–1.')
 output$dpcdown<-downloadHandler(function()'dpc_curve.csv',function(f)write.csv(curve(),f,row.names=FALSE))
 auddata<-reactive({d<-if(is.null(input$audfile)&&!is.null(shared_for('AUDPC')))shared_for('AUDPC') else read_example(input$audfile,'audpc.csv');validate(need(all(c('time','disease')%in%names(d)),'CSV must contain time,disease'));d<-d[order(d$time),];validate(need(nrow(d)>=2&&all(is.finite(d$time))&&all(is.finite(d$disease))&&all(diff(d$time)>0),'Need at least two finite, distinct times'));validate(need(all(d$disease>=0 & d$disease<=100),'Disease severity must be 0–100 percent'));d})
 output$audtable<-renderTable(auddata());output$audresult<-renderPrint({d<-auddata();a<-audpc(d$time,d$disease);cat('AUDPC:',a,'percent-days\nRelative AUDPC:',round(a/(100*(max(d$time)-min(d$time))),5))})
 output$audplot<-renderPlot({d<-auddata();plot(d$time,d$disease,type='b',pch=19,lwd=3,col='#358b9c',xlab='Day',ylab='Disease severity (%)',ylim=c(0,100))})
 output$auddown<-downloadHandler(function()'audpc_result.csv',function(f){d<-auddata();write.csv(data.frame(AUDPC=audpc(d$time,d$disease),rAUDPC=audpc(d$time,d$disease)/(100*diff(range(d$time)))),f,row.names=FALSE)})
 csv_numbers<-function(upload,column,text){if(is.null(upload))return(numbers(text));d<-read.csv(upload$datapath,check.names=FALSE);validate(need(column %in% names(d),paste('CSV must contain column:',column)));x<-suppressWarnings(as.numeric(d[[column]]));validate(need(length(x)>1 && all(is.finite(x)),'CSV must contain at least two finite numeric values'));x}
 countdata<-reactive({x<-if(is.null(input$countsfile)&&!is.null(shared_for('Count distributions')))shared_for('Count distributions')$diseased_count else csv_numbers(input$countsfile,'diseased_count',input$counts);validate(need(all(x>=0 & x==floor(x)),'Counts must be nonnegative integers'),need(mean(x)>0,'At least one positive count required'));count_distributions(x)})
 output$counttable<-renderTable(countdata(),digits=3);output$countplot<-renderPlot({d<-countdata();matplot(d$count,d[,2:4],type='b',pch=1:3,lty=1:3,col=c('#289a87','#f0a55e','#8872c3'),xlab='Count',ylab='Frequency');legend('topright',c('Observed','Poisson','Negative binomial'),lty=1:3,pch=1:3,col=c('#289a87','#f0a55e','#8872c3'),cex=.8)})
 output$countdown<-downloadHandler(function()'count_distributions.csv',function(f)write.csv(countdata(),f,row.names=FALSE))
 dispdata<-reactive({x<-if(is.null(input$dispfile)&&!is.null(shared_for('Dispersion')))shared_for('Dispersion')$diseased_count else csv_numbers(input$dispfile,'diseased_count',input$dispcounts);validate(need(all(x>=0 & x==floor(x)),'Counts must be nonnegative integers'));index_dispersion(x)})
 output$disptable<-renderTable(dispdata(),digits=4);output$dispdown<-downloadHandler(function()'dispersion.csv',function(f)write.csv(dispdata(),f,row.names=FALSE))
 runsdata<-reactive({x<-if(is.null(input$runsfile)&&!is.null(shared_for('Runs test')))shared_for('Runs test')$disease_status else csv_numbers(input$runsfile,'disease_status',input$binary);validate(need(all(x %in% c(0,1)),'Sequence must contain only 0 and 1'),need(length(unique(x))==2,'Need both disease states'));ordinary_runs(x)})
 output$runstable<-renderTable(runsdata(),digits=4);output$runsdown<-downloadHandler(function()'runs.csv',function(f)write.csv(runsdata(),f,row.names=FALSE))
 pointsdata<-reactive({d<-if(is.null(input$points)&&!is.null(shared_for('Nearest neighbour')))shared_for('Nearest neighbour') else read_example(input$points,'points.csv');validate(need(all(c('x','y')%in%names(d)),'Required x,y columns'),need(nrow(d)>=2,'At least 2 points'));d})
 nndata<-reactive({d<-pointsdata();clark_evans(d$x,d$y,input$area)})
 output$nntable<-renderTable(nndata(),digits=4);output$nnplot<-renderPlot({d<-pointsdata();plot(d$x,d$y,pch=19,col='#268b91',asp=1,xlab='X',ylab='Y')})
 output$nndown<-downloadHandler(function()'nearest_neighbour.csv',function(f)write.csv(nndata(),f,row.names=FALSE))
 netdata<-reactive({a<-if(is.null(input$network))as.matrix(read.csv('examples/network.csv',header=FALSE)) else as.matrix(read.csv(input$network$datapath,header=FALSE));validate(need(nrow(a)==ncol(a)&&nrow(a)>1,'Adjacency matrix must be square'),need(all(a%in%c(0,1))&&all(diag(a)==0),'Binary adjacency matrix with zero diagonal required'));network_metrics(a)})
 output$nettable<-renderTable(netdata());output$netdown<-downloadHandler(function()'network_metrics.csv',function(f)write.csv(netdata(),f,row.names=FALSE))
 # Distribution data: upload takes precedence over example.
 probobserved<-reactive({
   d<-if(is.null(input$probfile))read.csv(file.path('examples',input$probexample)) else read.csv(input$probfile$datapath,check.names=FALSE)
   validate(need(nrow(d)>=2,'Provide at least two observations'))
   d
 })
 observe({d<-probobserved(); numeric<-names(d)[vapply(d,is.numeric,logical(1))];updateSelectInput(session,'probcol',choices=numeric,selected=if('value'%in%numeric)'value' else numeric[1])})
 output$probpreview<-renderTable(head(probobserved(),10))
 probfit<-reactive({
   d<-probobserved();req(input$probcol);validate(need(input$probcol%in%names(d),'Select numeric column'))
   x<-d[[input$probcol]];x<-x[is.finite(x)];validate(need(length(x)>=2,'At least two valid values needed'))
   dist<-input$dist;manual<-identical(input$probmode,'manual');a<-input$p1;b<-input$p2;c<-input$p3
   if(dist%in%c('Poisson','Negative binomial','Binomial','Beta-binomial'))validate(need(all(x>=0 & x==floor(x)),'Count observations must be nonnegative integers'))
   if(dist=='Poisson'){lambda<-if(manual)a else mean(x);validate(need(lambda>0,'Mean count must be positive'));z<-0:max(max(x),qpois(.999,lambda));f<-dpois(z,lambda);pars<-c(lambda=lambda)}
   else if(dist=='Negative binomial'){validate(need(var(x)>mean(x),'Negative binomial moment fitting requires sample variance greater than mean'));mu<-if(manual)a else mean(x);size<-if(manual)c else mu^2/(var(x)-mu);validate(need(mu>0&&size>0,'Mean and size must be positive'));z<-0:max(max(x),qnbinom(.999,size=size,mu=mu));f<-dnbinom(z,size=size,mu=mu);pars<-c(mean=mu,size=size)}
   else if(dist%in%c('Binomial','Beta-binomial')){
     validate(need('trials'%in%names(d),'A trials column is required for binomial data'));n<-unique(d$trials);validate(need(length(n)==1&&is.finite(n)&&n>=1&&n==floor(n),'Trials must be a common positive integer'),need(all(x<=n),'Successes cannot exceed trials'))
     z<-0:n;p<-if(manual)b else mean(x)/n
     if(dist=='Binomial'){validate(need(p>=0&&p<=1,'p must be between 0 and 1'));f<-dbinom(z,n,p);pars<-c(trials=n,probability=p)}
     else {m<-mean(x/n);v<-var(x/n);rho<-if(manual)1/(a+b+1) else (v*n/(max(m*(1-m),1e-12))-1)/(n-1);validate(need(n>1&&rho>0&&rho<1,'Beta-binomial requires overdispersion (0 < rho < 1)'));alpha<-if(manual)a else m*(1/rho-1);beta<-if(manual)b else (1-m)*(1/rho-1);validate(need(alpha>0&&beta>0,'Positive shapes required'));f<-phyto_distributions(z,'beta_binomial',n=n,alpha=alpha,beta=beta);pars<-c(trials=n,alpha=alpha,beta=beta)}
   }
   else if(dist=='Normal'){mu<-if(manual)a else mean(x);sd<-if(manual)b else sd(x);validate(need(sd>0,'Standard deviation must be positive'));z<-seq(min(x,mu-4*sd),max(x,mu+4*sd),length.out=200);f<-dnorm(z,mu,sd);pars<-c(mean=mu,sd=sd)}
   else if(dist=='Exponential'){validate(need(all(x>=0),'Exponential observations must be nonnegative'));rate<-if(manual)a else 1/mean(x);validate(need(rate>0,'Rate must be positive'));z<-seq(0,max(x,5/rate),length.out=200);f<-dexp(z,rate);pars<-c(rate=rate)}
   else if(dist=='Beta'){validate(need(all(x>0&x<1),'Beta observations must lie strictly within (0,1)'));m<-mean(x);v<-var(x);phi<-m*(1-m)/v-1;validate(need(manual||phi>0,'Beta method-of-moments requires variance below m(1-m)'));alpha<-if(manual)a else m*phi;beta<-if(manual)c else (1-m)*phi;validate(need(alpha>0&&beta>0,'Shape parameters must be positive'));z<-seq(.001,.999,length.out=200);f<-dbeta(z,alpha,beta);pars<-c(alpha=alpha,beta=beta)}
   else {validate(need(all(x>0),'Gamma observations must be strictly positive'));shape<-if(manual)a else mean(x)^2/var(x);rate<-if(manual)b else mean(x)/var(x);validate(need(shape>0&&rate>0,'Shape and rate must be positive'));z<-seq(.001,max(x),length.out=200);f<-dgamma(z,shape=shape,rate=rate);pars<-c(shape=shape,rate=rate)}
   list(x=x,grid=z,y=f,params=pars,dist=dist,discrete=dist%in%c('Poisson','Negative binomial','Binomial','Beta-binomial'))
 })
 output$probparams<-renderTable({d<-probfit();data.frame(parameter=names(d$params),estimate=as.numeric(d$params))},digits=5)
 output$probplot<-renderPlot({d<-probfit();col<-'#3975d7';if(d$discrete){obs<-tabulate(match(d$x,d$grid),nbins=length(d$grid))/length(d$x);plot(d$grid,d$y,type='h',lwd=5,col=col,xlab='Observed count',ylab='Probability',main=paste(d$dist,'distribution'),ylim=c(0,max(c(d$y,obs))*1.18));points(d$grid,obs,pch=19,col='#ec7c33');legend('topright',c('Fitted','Observed frequency'),col=c(col,'#ec7c33'),lty=c(1,NA),pch=c(NA,19),bty='n')}else{hist(d$x,probability=TRUE,col='#c4d6f5',border='white',main=paste(d$dist,'distribution'),xlab='Observed value');lines(d$grid,d$y,col='#e35b69',lwd=3);legend('topright',c('Observed histogram','Fitted density'),fill=c('#c4d6f5',NA),border=NA,lty=c(NA,1),col=c(NA,'#e35b69'),bty='n')}})

 # Result-specific scientific interpretations, calculated from current user inputs.
 output$dpcinterpret <- renderText({
   yy <- tryCatch({t<-c(0,input$duration); y<-input$y0;r<-input$rate;switch(input$model,exponential=y*exp(r*t),monomolecular=1-(1-y)*exp(-r*t),logistic=1/(1+((1-y)/y)*exp(-r*t)),gompertz=exp(log(y)*exp(-r*t)),linear=y+r*t)},error=function(e) numeric())
   if(length(yy)!=2 || any(!is.finite(yy))) return('Review model parameters and simulated disease curve.')
   paste0('Selected model: ',input$model,'. Initial disease: ',round(100*yy[1],2),'%; predicted at day ',input$duration,': ',round(100*yy[2],2),'%. Change: ',round(100*(yy[2]-yy[1]),2),' percentage points. ',if(yy[2]>1)'The prediction exceeds 100%, so this model is unsuitable over the selected interval.' else 'This describes simulated epidemic development, not a fitted or independently validated forecast.')
 })
 output$audinterpret <- renderText({d<-auddata(); a<-audpc(d$time,d$disease); duration<-diff(range(d$time)); paste0('Across ',nrow(d),' assessments over ',round(duration,2),' days, cumulative disease burden (AUDPC) = ',round(a,3),' %-days; relative AUDPC = ',round(a/(100*duration),4),' (',round(a/duration,2),'% average time-weighted severity). Severity changed from ',round(d$disease[1],2),'% to ',round(tail(d$disease,1),2),'%. Higher AUDPC indicates greater cumulative disease intensity; compare only matching observation windows and measurement scales.')})
 output$countinterpret <- renderText({x<-csv_numbers(input$countsfile,'diseased_count',input$counts);m<-mean(x);v<-var(x);paste0('Across ',length(x),' sampling units, mean count = ',round(m,3),', sample variance = ',round(v,3),' and variance-to-mean ratio = ',round(v/m,3),'. ',if(v>m)'Counts are overdispersed relative to Poisson; a negative-binomial model may better accommodate heterogeneity.' else if(v<m)'Counts are underdispersed relative to Poisson; check sampling restrictions and alternative count models.' else 'Mean and variance are similar, consistent with a Poisson benchmark.',' This is descriptive, not a formal goodness-of-fit conclusion.')})
 output$dispinterpret <- renderText({d<-dispdata(); z<-as.numeric(d$D[1]);paste0('Index of dispersion D = ',round(z,3),'. ',if(z>1)'Variance exceeds the mean, indicating overdispersion relative to the Poisson benchmark.' else if(z<1)'Variance is below the mean, indicating a more uniform count pattern than Poisson.' else 'Variance equals the mean, consistent with the Poisson benchmark.',' Overdispersion alone does not establish spatial clustering without a suitable spatial sampling design.')})
 output$runsinterpret <- renderText({x<-csv_numbers(input$runsfile,'disease_status',input$binary);n1<-sum(x==1);n0<-sum(x==0);obs<-1+sum(diff(x)!=0);expected<-1+2*n1*n0/length(x);paste0('Observed runs = ',obs,'; expected under random ordering = ',round(expected,2),'. ',if(obs<expected)'Fewer runs suggest contiguous disease states (possible aggregation along the sampled order).' else if(obs>expected)'More runs suggest greater alternation of diseased and healthy observations.' else 'Observed and expected runs coincide.',' Interpret with the sampling sequence and sample size; this comparison is not by itself a significance test.')})
 output$nninterpret <- renderText({d<-nndata();nms<-names(d);idx<-grep('(^R$|ratio|clark)',nms,ignore.case=TRUE);if(!length(idx))return(paste('Computed nearest-neighbour statistics:',paste(nms,collapse=', ')));r<-as.numeric(d[[idx[1]]][1]);paste0('Clark-Evans ratio R = ',round(r,3),'. ',if(r<1)'Observed points are closer than expected under complete spatial randomness, consistent with aggregation.' else if(r>1)'Observed points are farther apart than expected, consistent with regular spacing.' else 'Observed mean nearest-neighbour distance equals the CSR expectation.',' No boundary correction or significance test is applied; use planar coordinates and an appropriate study-window area.')})
 output$netinterpret <- renderText({d<-netdata();paste0('Network analysis returned ',nrow(d),' node/metric records. Columns: ',paste(names(d),collapse=', '),'. Higher out-degree indicates more outgoing directed connections; higher in-degree indicates more incoming connections. These metrics describe topology, not confirmed pathogen transmission or causality.')})

 output$probinterpret<-renderText({d<-probfit();x<-d$x;m<-mean(x);v<-var(x);paste0('Fitted distribution: ',d$dist,'; n = ',length(x),'; mean = ',round(m,3),'; variance = ',round(v,3),'; variance/mean = ',if(m!=0)round(v/m,3) else 'undefined','. Parameters: ',paste(paste(names(d$params),round(d$params,4),sep=' = '),collapse='; '),'. ',if(d$dist=='Negative binomial')'The model allows variance to exceed the mean and can represent heterogeneous pathogen counts.' else if(d$dist=='Poisson')'A Poisson model assumes equal mean and variance; departures suggest lack of fit or heterogeneity.' else if(d$dist%in%c('Binomial','Beta-binomial'))'These models describe success counts out of known trials; check trial denominators and independence.' else 'The fitted curve describes the observed continuous-variable distribution.',' Compare plotted observed and fitted values before accepting model adequacy. Parameter uncertainty and formal fit testing are not implemented here.')})
 output$probtable<-renderTable({d<-probfit();head(data.frame(x=d$grid,density_or_probability=d$y),20)},digits=5)
 output$probdn<-downloadHandler(function()'distribution_fit.csv',function(f){d<-probfit();write.csv(data.frame(x=d$grid,density_or_probability=d$y),f,row.names=FALSE)})
 output$probexampledown<-downloadHandler(function()input$probexample,function(f)file.copy(file.path('examples',input$probexample),f))
 # Venn sets are calculated from uploaded dataset-level capability indicators.
 venn_data<-reactive({
   d<-if(is.null(input$vennfile))read.csv('examples/complex_venn_dataset_capabilities.csv',stringsAsFactors=FALSE,check.names=FALSE) else read.csv(input$vennfile$datapath,stringsAsFactors=FALSE,check.names=FALSE)
   validate(need('dataset_id'%in%names(d),'A dataset_id column is required.'),need(!anyDuplicated(d$dataset_id),'dataset_id must be unique.'))
   flags<-setdiff(names(d),'dataset_id'); flags<-flags[vapply(d[flags],function(z)all(!is.na(z) & z %in% c(0,1)),logical(1))]
   validate(need(length(flags)>=1,'Supply at least one binary 0/1 capability column.'),need(length(flags)<=12,'Maximum 12 capability columns; use UpSet for more than four.'))
   attr(d,'flags')<-flags;d
 })
 output$vennpreview<-renderTable(head(venn_data(),8),striped=TRUE)
 venn_summary<-reactive({d<-venn_data();flags<-attr(d,'flags');bits<-apply(d[,flags,drop=FALSE],1,paste0,collapse='');tb<-sort(table(bits),decreasing=TRUE);data.frame(pattern=names(tb),count=as.integer(tb),stringsAsFactors=FALSE)})
 output$vennplot<-renderPlot({
   d<-venn_data();flags<-attr(d,'flags');k<-length(flags);sets<-lapply(flags,function(n)as.character(d$dataset_id[d[[n]]==1]));names(sets)<-gsub('_',' ',flags)
   if(identical(input$vennmode,'venn')&&k>=2&&k<=4&&requireNamespace('VennDiagram',quietly=TRUE)){
     grid::grid.newpage();pal<-c('#a6dcef','#f8c3d5','#c8e8bf','#f8dcae');g<-VennDiagram::venn.diagram(x=sets,filename=NULL,fill=pal[seq_len(k)],alpha=.5,col=pal[seq_len(k)],cex=1,cat.cex=.9,margin=.13);grid::grid.draw(g)
   }else{
     sm<-head(venn_summary(),18);lab<-vapply(strsplit(sm$pattern,''),function(z){paste(gsub('_',' ',flags)[which(z=='1')],collapse=' + ')},character(1));lab[!nzchar(lab)]<-'None'
     op<-par(mar=c(5,min(19,max(10,max(nchar(lab))*.6)),3,2));on.exit(par(op));barplot(rev(sm$count),names.arg=rev(lab),horiz=TRUE,las=1,col=rep(c('#a6dcef','#f8c3d5','#c8e8bf','#f8dcae'),length.out=nrow(sm)),border=NA,xlab='Number of datasets',main=paste(k,'data categories: exact overlaps'),cex.names=.75)
   }
 })
 output$venntable<-renderTable(venn_summary(),striped=TRUE)
 output$venninterpret<-renderText({d<-venn_data();flags<-attr(d,'flags');n<-rowSums(d[,flags,drop=FALSE]);paste('Datasets:',nrow(d),'| Categories:',length(flags),'| At least two capabilities:',sum(n>=2),'| All capabilities:',sum(n==length(flags)),'. The diagram automatically uses',if(length(flags)<=4&&length(flags)>=2&&identical(input$vennmode,'venn')&&requireNamespace('VennDiagram',quietly=TRUE))paste(length(flags),'circles') else 'an exact-intersection bar chart','; overlaps are descriptive, not tests of association.')})
 output$vennexample<-downloadHandler(function()'complex_venn_dataset_capabilities.csv',function(f)file.copy('examples/complex_venn_dataset_capabilities.csv',f))
 output$vennresults<-downloadHandler(function()'venn_intersections.csv',function(f)write.csv(venn_summary(),f,row.names=FALSE))
 forecast_raw<-reactive({d<-if(is.null(input$forecastfile)&&!is.null(shared_for('Disease forecasting & thresholds')))shared_for('Disease forecasting & thresholds') else if(is.null(input$forecastfile))read.csv(file.path('examples',input$forecastexample)) else read.csv(input$forecastfile$datapath);validate(need(all(c('time','disease')%in%names(d)),'Required columns: time,disease'));d})
 output$forecastgroups<-renderUI({d<-forecast_raw();lapply(intersect(c('site','treatment','replicate'),names(d)),function(col)selectInput(paste0('fg_',col),paste('Select',col),choices=unique(as.character(d[[col]]))))})
 forecastdata<-reactive({d<-forecast_raw();for(col in intersect(c('site','treatment','replicate'),names(d))){sel<-input[[paste0('fg_',col)]];req(sel);d<-d[as.character(d[[col]])==sel,,drop=FALSE]};validate(need(nrow(d)>=4,'At least four observations required for the selected series'));d$time<-suppressWarnings(as.numeric(d$time));d$disease<-suppressWarnings(as.numeric(d$disease));validate(need(all(is.finite(d$time)&is.finite(d$disease)),'Time and disease must be numeric and finite'),need(!anyDuplicated(d$time),'One observation per time point is required for selected series'),need(all(d$disease>0&d$disease<100),'For fitting, disease values must be strictly between 0 and 100'));d[order(d$time),,drop=FALSE]})
 output$forecastpreview<-renderTable(head(forecastdata(),12),striped=TRUE)
 output$forecast_dictionary<-downloadHandler(function()'forecast_column_guide.csv',function(f){write.csv(data.frame(column=c('site','treatment','replicate','time','disease','temperature_c','relative_humidity_pct','rainfall_mm'),meaning=c('Experimental location','Disease-management treatment','Independent experimental unit','Days since initial observation','Disease incidence or severity, percent','Temperature, Celsius (context only)','Relative humidity, percent (context only)','Rainfall, millimetres (context only)'),required=c(FALSE,FALSE,FALSE,TRUE,TRUE,FALSE,FALSE,FALSE)),f,row.names=FALSE)})
 forecastfit<-reactive({d<-forecastdata();t<-d$time;y<-d$disease/100;m<-input$forecastmodel
   transformed<-switch(m,logistic=qlogis(y),gompertz=log(-log(y)),monomolecular=log(1-y));fit<-lm(transformed~t)
   validate(need(all(is.finite(coef(fit))),'Unable to fit model'))
   pred<-function(tt){z<-coef(fit)[1]+coef(fit)[2]*tt;switch(m,logistic=plogis(z),gompertz=exp(-exp(z)),monomolecular=1-exp(z))}
   horizon<-input$forecastdays;grid<-seq(min(t),max(t)+horizon,length.out=400);yy<-100*pred(grid);validate(need(all(is.finite(yy)),'Invalid forecast: check data and model'))
   crossings<-vapply(c(input$threshold1,input$threshold2),function(th){v<-yy-th;idx<-which(v[-length(v)]<0 & v[-1]>=0);if(!length(idx))return(NA_real_);i<-idx[1];grid[i]+(grid[i+1]-grid[i])*(-v[i])/(v[i+1]-v[i])},numeric(1))
   list(observed=d,curve=data.frame(time=grid,predicted_pct=yy),thresholds=data.frame(threshold_pct=c(input$threshold1,input$threshold2),crossing_day=round(crossings,2)),slope=unname(coef(fit)[2]))
 })
 output$forecastplot<-renderPlot({d<-forecastfit();plot(d$curve$time,d$curve$predicted_pct,type='l',col='#168f91',lwd=3,ylim=c(0,100),xlab='Time (days)',ylab='Disease (%)',main='Fitted disease curve and forecast');points(d$observed$time,d$observed$disease,pch=19,col='#e85a67');abline(v=max(d$observed$time),lty=3,col='#666666');abline(h=input$threshold1,col='#d0a227',lty=2,lwd=2);abline(h=input$threshold2,col='#b84d94',lty=2,lwd=2);legend('topleft',c('Model forecast','Observed','Forecast begins','Early threshold','Action threshold'),col=c('#168f91','#e85a67','#666666','#d0a227','#b84d94'),lty=c(1,NA,3,2,2),pch=c(NA,19,NA,NA,NA),bty='n',cex=.8)})
 output$forecasttable<-renderTable(forecastfit()$thresholds)
 output$forecastinterpret<-renderText({d<-forecastfit();last<-max(d$observed$time);cross<-d$thresholds;status<-vapply(seq_len(nrow(cross)),function(i){t<-cross$crossing_day[i];paste0(cross$threshold_pct[i],'% threshold: ',if(is.na(t))'not crossed within the modelled interval' else if(t<=last)paste0('crossed at day ',t,' (during observed period)') else paste0('projected crossing at day ',t,' (',round(t-last,2),' days after last observation)'))},character(1));paste0('Fitted ',input$forecastmodel,' trajectory for ',nrow(d$observed),' observations; observed severity changed from ',round(d$observed$disease[1],2),'% to ',round(tail(d$observed$disease,1),2),'%. ',paste(status,collapse='; '),'. These thresholds describe the fitted time curve, not a weather-based, externally validated early-warning system. Interpret extrapolated dates cautiously.')})
 output$forecastdown<-downloadHandler(function()'disease_forecast.csv',function(f)write.csv(forecastfit()$curve,f,row.names=FALSE))
 output$forecast_example_download<-downloadHandler(function()input$forecastexample,function(f)file.copy(file.path('examples',input$forecastexample),f))


 # Scientific validation module: independent time-series selection and original-scale model fits.
 adv_use_example <- reactiveVal(TRUE)
 observeEvent(input$adv_example,{adv_use_example(TRUE)})
 observeEvent(input$adv_file,{adv_use_example(FALSE)})
 adv_raw <- reactive({
   if(!adv_use_example() && !is.null(input$adv_file)) d<-read.csv(input$adv_file$datapath,check.names=FALSE) else d<-read.csv('examples/PowderyMildew_published.csv')
   if(!'severity_pct'%in%names(d) && 'disease_proportion'%in%names(d))d$severity_pct<-100*as.numeric(d$disease_proportion)
   validate(need(all(c('time','severity_pct')%in%names(d)),'Need time and severity_pct or disease_proportion columns'))
   d$time<-suppressWarnings(as.numeric(d$time));d$severity_pct<-suppressWarnings(as.numeric(d$severity_pct))
   validate(need(all(is.finite(d$time)&is.finite(d$severity_pct)&d$severity_pct>=0&d$severity_pct<=100),'Invalid time or disease severity'))
   d
 })
 observe({d<-adv_raw();for(col in c('treatment','moisture','replicate')){
   choices<-if(col%in%names(d))unique(as.character(d[[col]])) else 'All'
   updateSelectInput(session,paste0('adv_',col),choices=choices,selected=choices[1])
 }})
 adv_series<-reactive({d<-adv_raw();for(col in c('treatment','moisture','replicate'))if(col%in%names(d)){
   req(input[[paste0('adv_',col)]]);d<-d[as.character(d[[col]])==input[[paste0('adv_',col)]],,drop=FALSE]
 };validate(need(nrow(d)>=5,'Select a series with at least five observations'));d[order(d$time),,drop=FALSE]})
 output$adv_preview<-renderTable(adv_series(),striped=TRUE)
 adv_fit<-reactive({req(input$adv_models);tryCatch(pe_compare(adv_series(),input$adv_models,input$adv_weighting),error=function(e)validate(need(FALSE,conditionMessage(e))))})
 output$adv_comparison<-renderTable(adv_fit()$comparison,digits=3,striped=TRUE)
 adv_band<-reactive({if(!isTRUE(input$adv_show_band)||input$adv_weighting!='unweighted')return(NULL);d<-adv_series();grid<-seq(min(0,min(d$time)),max(d$time)+input$adv_horizon,length.out=300);pe_bootstrap_curve(d,adv_fit()$best$model,grid,B=input$adv_boot_n)})
 output$adv_plot<-renderPlot({d<-adv_series();f<-adv_fit();best<-f$best;last<-max(d$time);grid<-seq(min(d$time),last+input$adv_horizon,length.out=500)
   plot(d$time,d$severity_pct,pch=19,col='#e4777e',xlim=range(grid),ylim=c(0,100),xlab='Days',ylab='Disease severity (%)',main=paste('Best fitting model:',best$model))
   band<-adv_band();if(!is.null(band))polygon(c(band$grid,rev(band$grid)),c(band$low,rev(band$high)),col='#c8e8e2',border=NA);lines(grid,best$predict(grid),col='#178d89',lwd=3);points(d$time,d$severity_pct,pch=19,col='#e4777e');abline(v=last,lty=3,col='#777777');abline(h=c(input$adv_threshold1,input$adv_threshold2),col=c('#dfa545','#a57cc5'),lty=2)
   legend('topleft',legend=c('Observed','Fitted / extrapolated','Last observed day'),pch=c(19,NA,NA),lty=c(NA,1,3),col=c('#e4777e','#178d89','#777777'),bty='n')})
 output$adv_residual<-renderPlot({d<-adv_fit()$best$observed;plot(d$time,d$residual_pct,pch=19,col='#5477b4',xlab='Time (days)',ylab='Observed - fitted (percentage points)',main='Residuals over time');abline(h=0,lty=2,col='#b76e79')})
 output$adv_holdout<-renderTable({pe_rolling_origin(adv_series(),adv_fit()$best$model)},digits=3)
 adv_cross<-reactive({f<-adv_fit()$best;last<-max(adv_series()$time);do.call(rbind,lapply(c(input$adv_threshold1,input$adv_threshold2),function(th)pe_crossing(f,th,last,input$adv_horizon,origin=0,boot=if(!is.null(adv_band()))adv_band()$samples else NULL,boot_grid=if(!is.null(adv_band()))adv_band()$grid else NULL)))})
 output$adv_crossings<-renderTable(adv_cross(),digits=2)
 adv_audpc<-reactive({d<-adv_raw();validate(need('replicate'%in%names(d),'Replicate column is needed for independent experimental-unit AUDPC'));pe_audpc_groups(d)})
 output$adv_audpc_table<-renderTable(adv_audpc(),digits=4)
 adv_summary<-reactive({d<-adv_audpc();grp<-intersect(c('treatment','moisture'),names(d));if(!length(grp))return(data.frame(n=nrow(d),mean_AUDPC=mean(d$AUDPC),SD=sd(d$AUDPC)))
   aggregate(d$AUDPC,by=d[grp],FUN=function(x)c(n=length(x),mean=mean(x),sd=sd(x)))})
 output$adv_audpc_summary<-renderTable(adv_summary(),digits=3)
 output$adv_anova<-renderPrint({d<-adv_audpc();if(!all(c('treatment','moisture','replicate')%in%names(d))){cat('Factorial comparison requires treatment, moisture, replicate columns.');return()}
   # No pooling of repeated dates: independent replicate-level AUDPC only.
   if(length(unique(d$treatment))<2||length(unique(d$moisture))<2){cat('Need at least two treatment and moisture levels');return()}
   if(length(unique(d$start_day))!=1||length(unique(d$end_day))!=1){cat('Different observation windows: do not compare raw AUDPC');return()}
   fit<-aov(AUDPC~treatment*moisture,data=d);print(summary(fit));cat('\nExploratory fixed-effects ANOVA. Confirm randomization, blocking and residual assumptions before inference.\n')})
 output$adv_interpret<-renderText({f<-adv_fit();b<-f$best;h<-pe_rolling_origin(adv_series(),b$model);c<-adv_cross();lag<-b$metrics$lag1_residual_cor
   paste0('Selected series: ',nrow(adv_series()),' assessments. Preferred candidate under ',input$adv_weighting,': ',b$model,'. In-sample RMSE ',round(b$metrics$RMSE_pct,2),' percentage points. Rolling-origin RMSE ',round(h$rolling_RMSE_pct,2),' (',h$n_test,' one-step tests; descriptive only). Residual lag-1 correlation ',round(lag,2),'. ',if(is.finite(lag)&&abs(lag)>.3)'Residual temporal pattern warrants investigation. ' else '',paste(paste0(c$threshold_pct,'%: ',c$status,'; estimated day ',round(c$model_crossing_day,1)),collapse=' | '),'. Bootstrap bands are illustrative iid-residual sensitivity intervals, not calibrated prediction intervals. AICc is not a formal correlated-data ranking.')})
 output$edu_cfi <- renderText({paste('Composite fitness index (CFI) =',format(input$edu_if * input$edu_la * input$edu_sc, digits=7),'sporangia per inoculated leaflet (under stated measurement definitions).')})
 output$adv_example_download<-downloadHandler(function()'PowderyMildew_published.csv',function(f)file.copy('examples/PowderyMildew_published.csv',f))
 output$adv_audpc_download<-downloadHandler(function()'replicate_AUDPC.csv',function(f)write.csv(adv_audpc(),f,row.names=FALSE))
 output$adv_fits_download<-downloadHandler(function()'model_comparison.csv',function(f)write.csv(adv_fit()$comparison,f,row.names=FALSE))
 output$adv_forecast_download<-downloadHandler(function()'model_forecast_and_thresholds.csv',function(f){b<-adv_fit()$best;d<-adv_series();grid<-seq(min(d$time),max(d$time)+input$adv_horizon,length.out=500);write.csv(data.frame(day=grid,predicted_severity_pct=b$predict(grid),period=ifelse(grid<=max(d$time),'fitted interval','extrapolated forecast')),f,row.names=FALSE)})


 extra_data <- function(upload,example){if(!is.null(upload)) read.csv(upload$datapath,check.names=FALSE) else read.csv(file.path('examples',example),check.names=FALSE)}
 extra_numeric <- function(d,fields){validate(need(all(fields %in% names(d)),paste('Required columns:',paste(fields,collapse=', '))));for(k in fields)d[[k]]<-suppressWarnings(as.numeric(d[[k]]));validate(need(all(is.finite(as.matrix(d[fields]))),'All required measurements must be finite numbers.'));d}
 cfi_calc <- reactive({d<-extra_numeric(extra_data(input$cfi_file,'01_CFI_replicated.csv'),c('infection_frequency','lesion_area_cm2','sporulation_per_cm2'));validate(need(all(d$infection_frequency>=0 & d$infection_frequency<=1 & d$lesion_area_cm2>=0 & d$sporulation_per_cm2>=0),'CFI inputs must be nonnegative; infection frequency must be between zero and one.'));d$calculated_CFI<-d$infection_frequency*d$lesion_area_cm2*d$sporulation_per_cm2;d})
 output$cfi_table<-renderTable(cfi_calc(),digits=3)
 output$cfi_plot<-renderPlot({d<-cfi_calc();g<-if('isolate'%in%names(d))as.factor(d$isolate) else factor(seq_len(nrow(d)));boxplot(d$calculated_CFI~g,col='#a8d9c6',xlab='Isolate',ylab='CFI',main='Composite fitness by isolate');stripchart(d$calculated_CFI~g,vertical=TRUE,method='jitter',add=TRUE,pch=19,col='#287d8e')})
 output$cfi_note<-renderText({d<-cfi_calc();paste('Calculated',nrow(d),'replicate-level values. CFI range:',round(min(d$calculated_CFI),2),'to',round(max(d$calculated_CFI),2),'. Larger CFI indicates greater combined infection, lesion development and sporulation under this measurement protocol; it is not a universal fitness scale.')})
 output$cfi_download<-downloadHandler(function()'CFI_results.csv',function(f)write.csv(cfi_calc(),f,row.names=FALSE))
 poly_calc<-reactive({d<-extra_numeric(extra_data(input$poly_file,'06_Polyetic_seasons.csv'),c('season','initial_inoculum_index','final_incidence_pct'));validate(need(all(d$final_incidence_pct>=0 & d$final_incidence_pct<=100),'Incidence must be 0–100%.'));d[order(d$season),]})
 output$poly_table<-renderTable(poly_calc())
 output$poly_plot<-renderPlot({d<-poly_calc();plot(d$season,d$final_incidence_pct,type='b',pch=19,lwd=2,col='#4b9a8e',xlab='Season',ylab='Final incidence (%)',main='Interannual epidemic intensity');par(new=TRUE);plot(d$season,d$initial_inoculum_index,type='b',pch=17,col='#d89b69',axes=FALSE,xlab='',ylab='');axis(4,col.axis='#b47845');mtext('Initial inoculum index',side=4,line=2,col='#b47845')})
 output$poly_note<-renderText({d<-poly_calc();paste('Across',nrow(d),'seasons, final incidence ranges from',min(d$final_incidence_pct),'to',max(d$final_incidence_pct),'%. This illustrates interannual variation; the inoculum index and final incidence may have different scales. No carryover mechanism is inferred.')})
 output$poly_download<-downloadHandler(function()'polyetic_results.csv',function(f)write.csv(poly_calc(),f,row.names=FALSE))
 grad_calc<-reactive({d<-extra_numeric(extra_data(input$grad_file,'07_Pathogen_gradient.csv'),c('distance_m','disease_pct'));validate(need(all(d$distance_m>=0 & d$disease_pct>=0 & d$disease_pct<=100),'Distance must be nonnegative and disease 0–100%.'));d[order(d$distance_m),]})
 output$grad_table<-renderTable(grad_calc())
 output$grad_plot<-renderPlot({d<-grad_calc();plot(d$distance_m,d$disease_pct,pch=19,col='#378c86',xlab='Distance (m)',ylab='Disease (%)',main='Observed disease gradient');if(nrow(d)>=3){fit<-lm(disease_pct~distance_m,data=d);abline(fit,col='#dd947d',lwd=2)}})
 output$grad_note<-renderText({d<-grad_calc();if(nrow(d)<3)return('At least three observations needed for a descriptive linear trend.');fit<-lm(disease_pct~distance_m,data=d);paste('Observed linear slope:',round(coef(fit)[2],3),'percentage points per metre; descriptive R-squared:',round(summary(fit)$r.squared,3),'. A linear trend is not necessarily the biologically correct dispersal kernel.')})
 output$grad_download<-downloadHandler(function()'gradient_results.csv',function(f)write.csv(grad_calc(),f,row.names=FALSE))
 two_calc<-reactive({d<-extra_numeric(extra_data(input$two_file,'08_Two_pathogen_yield.csv'),c('pathogen_A_severity_pct','pathogen_B_severity_pct','yield_kg','attainable_yield_kg'));validate(need(all(d$pathogen_A_severity_pct>=0 & d$pathogen_A_severity_pct<=100 & d$pathogen_B_severity_pct>=0 & d$pathogen_B_severity_pct<=100 & d$attainable_yield_kg>0 & d$yield_kg>=0 & d$yield_kg<=d$attainable_yield_kg),'Severity must be 0–100%; attainable yield positive; observed yield between zero and attainable.'));d$yield_loss_pct<-100*(d$attainable_yield_kg-d$yield_kg)/d$attainable_yield_kg;d})
 output$two_table<-renderTable(two_calc(),digits=2)
 output$two_plot<-renderPlot({d<-two_calc();plot(d$pathogen_A_severity_pct,d$yield_loss_pct,pch=19,col='#7bb4a8',cex=1.4,xlab='Pathogen A severity (%)',ylab='Yield loss relative to supplied attainable yield (%)',main='Exploratory two-pathogen burden');text(d$pathogen_A_severity_pct,d$yield_loss_pct,labels=round(d$pathogen_B_severity_pct),pos=3,cex=.8,col='#bc7864');legend('topleft',legend='Point labels = pathogen B severity (%)',bty='n',cex=.8)})
 output$two_note<-renderText({d<-two_calc();paste('Across',nrow(d),'plots, calculated yield loss ranges from',round(min(d$yield_loss_pct),1),'to',round(max(d$yield_loss_pct),1),'%. Pathogen A and B may co-occur, but independent replication and experimental controls are required to estimate interaction and attribute losses.')})
 output$two_download<-downloadHandler(function()'two_pathogen_yield_results.csv',function(f)write.csv(two_calc(),f,row.names=FALSE))
 pe_extension_server(input,output,session,forecastfit)

}
shinyApp(ui,server)
