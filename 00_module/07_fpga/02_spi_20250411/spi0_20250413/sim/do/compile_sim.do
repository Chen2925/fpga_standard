vlib work
vmap work

# sim model

#=======================================
# define
#=======================================

vlog -reportprogress 300 -work work      sim_model/define/define.v

#=======================================
# sim_model
#=======================================

vlog -reportprogress 300 +define+tb_00=1 -work work  +incdir+{sim_model/define} sim_model/sim_model.v
vlog -reportprogress 300 +define+tb_00=1 -work work  +incdir+{sim_model/define} sim_model/tb_top.v

