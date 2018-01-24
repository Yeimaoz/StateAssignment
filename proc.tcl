#!/bin/tclsh
proc down_scale_clk_period { design_path design_name clk_period clk_period_scale } {
    echo start_down_scale_clk_period 
    echo current_design $design_name
    read_file -format verilog ./$design_path/$design_name > /dev/null
    
    #bind clock source
    echo set_up_clk_period $clk_period
    create_clock -name clk -period $clk_period { clk }
    
    #compiler my design
    echo compile_design
    compile -map_effort high -boundary_optimization > ./report_compile/$design_name.report
    
    #check slack
    echo check_slack
    set neg_slack [ exec tcsh -c "./extract_slack $design_name" ] 
    return $neg_slack
}

proc fast_down_scale_clk_period { design_path design_name clk_period clk_period_scale } {
    echo start_down_scale_clk_period 
    echo current_design $design_name
    read_file -format verilog ./$design_path/$design_name > /dev/null
    
    #bind clock source
    echo set_up_clk_period $clk_period
    create_clock -name clk -period $clk_period { clk }
    
    #compiler my design
    echo compile_design
    compile -map_effort high -boundary_optimization > ./report_compile/$design_name.report
    
    #report_timing to file
    report_timing > ./report_timing/$design_name.report
    
    #check slack
    echo check_slack
    
    set neg_slack [ exec bash -c "./get_slack $design_name" ] 
    return $neg_slack
}
