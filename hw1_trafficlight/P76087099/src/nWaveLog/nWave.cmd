wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 \
           {/home/Minhnvl/Computer_Organization/1. Code_of_Minh/hw1_trafficlight/P76087099/src/triffic_light2.fsdb}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/traffic_light_tb"
wvGetSignalSetScope -win $_nWave1 "/traffic_light_tb/ul"
wvSetPosition -win $_nWave1 {("G1" 9)}
wvSetPosition -win $_nWave1 {("G1" 9)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/traffic_light_tb/ul/G} \
{/traffic_light_tb/ul/R} \
{/traffic_light_tb/ul/Y} \
{/traffic_light_tb/ul/clk} \
{/traffic_light_tb/ul/count_cycle\[15:0\]} \
{/traffic_light_tb/ul/numofstate\[31:0\]} \
{/traffic_light_tb/ul/out\[2:0\]} \
{/traffic_light_tb/ul/pass} \
{/traffic_light_tb/ul/rst} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 5 6 7 8 9 )} 
wvSetPosition -win $_nWave1 {("G1" 9)}
wvGetSignalClose -win $_nWave1
wvSelectGroup -win $_nWave1 {G2}
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 5 )} 
wvSelectSignal -win $_nWave1 {( "G1" 5 )} 
wvSetRadix -win $_nWave1 -format UDec
wvSetCursor -win $_nWave1 200524.287703 -snap {("G2" 0)}
wvSetCursor -win $_nWave1 4865119.235894 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 4865945.878443
wvSetCursor -win $_nWave1 4864801.932358
wvSetCursor -win $_nWave1 4864363.158517 -snap {("G1" 8)}
wvSetCursor -win $_nWave1 2305083.276083 -snap {("G1" 8)}
wvSetCursor -win $_nWave1 2306321.245134 -snap {("G1" 8)}
wvSetCursor -win $_nWave1 4860856.520630 -snap {("G1" 8)}
wvSetCursor -win $_nWave1 2305381.015474 -snap {("G1" 8)}
wvExit
