# GitHub release checklist

1. Extract the entire archive and run `shiny::runApp(".")` in its application directory.
2. Test all eight dropdown menus and all nested tabs.
3. Upload representative example CSV files; check column mapping and analysis routing.
4. Verify incidence, severity and density with known values (P1: 20%, 6%, 6 lesions/m2).
5. Verify AUDPC and rAUDPC with hand-calculated fixtures.
6. Confirm charts use epidemiologically appropriate axes and legends.
7. Run multi-file consolidated reports, including original tables, calculations, units, equations, interpretations and missing-input notices.
8. Check exported report and filenames.
9. Record `sessionInfo()` and test outputs.
10. Choose and add a software license and permanent DOI.
