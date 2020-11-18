###############################################################################
##
## BSD 3-Clause License
##
## Copyright (c) 2019, University of California, San Diego.
## All rights reserved.
##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions are met:
##
## * Redistributions of source code must retain the above copyright notice, this
##   list of conditions and the following disclaimer.
##
## * Redistributions in binary form must reproduce the above copyright notice,
##   this list of conditions and the following disclaimer in the documentation
##   and#or other materials provided with the distribution.
##
## * Neither the name of the copyright holder nor the names of its
##   contributors may be used to endorse or promote products derived from
##   this software without specific prior written permission.
##
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
## AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
## IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
## ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
## LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
## CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
## SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
## INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
## CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
## ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
## POSSIBILITY OF SUCH DAMAGE.
##
################################################################################

#--------------------------------------------------------------------
# Partition netlist command
#--------------------------------------------------------------------

sta::define_cmd_args "partition_netlist" { [-tool name] \
                                           [-num_partitions value] \
                                           [-graph_model name] \
                                           [-clique_threshold value] \
                                           [-weight_model name] \
                                           [-max_edge_weight value] \
                                           [-max_vertex_weight value] \
                                           [-num_starts value] \
                                           [-balance_constraint value] \
                                           [-coarsening_ratio value] \
                                           [-coarsening_vertices value] \
                                           [-enable_term_prop value] \
                                           [-cut_hop_ratio value] \
                                           [-architecture value] \
                                           [-refinement value] \
                                           [-seeds value] \
                                           [-partition_id value] \
                                           [-force_graph value] \
                                         }
proc partition_netlist { args } {
  sta::parse_key_args "partition_netlist" args \
    keys {-tool \
          -num_partitions \
          -graph_model \
          -clique_threshold \
          -weight_model \
          -max_edge_weight \
          -max_vertex_weight \
          -num_starts \
          -balance_constraint \
          -coarsening_ratio \
          -coarsening_vertices \
          -enable_term_prop \
          -cut_hop_ratio \ 
          -architecture \
          -refinement \
          -seeds \
          -partition_id \
          -force_graph \
         } flags {}

  # Tool
  set tools "chaco gpmetis mlpart"
  if { ![info exists keys(-tool)] } {
    ord::error "missing mandatory argument -tool" 
  } elseif { !($keys(-tool) in $tools) } {
    ord::error "invalid tool. Use one of the following: $tools"
  } else {
     PartClusManager::set_tool $keys(-tool)
  }

  # Clique threshold
  if { [info exists keys(-clique_threshold)] } {
    if { !([string is integer $keys(-clique_threshold)] && \
           $keys(-clique_threshold) >= 3 && $keys(-clique_threshold) <= 32768) } {
      ord::error "argument -clique_threshold should be an integer in the range \[3, 32768\]"
    } else {
      PartClusManager::set_clique_threshold $keys(-clique_threshold)
    }
  } else {
    PartClusManager::set_clique_threshold 50
  }

  # Graph model
  set graph_models "clique star hybrid"
  if { [info exists keys(-graph_model)] } {
    if { $keys(-graph_model) in $graph_models } {
    } else {
      ord::error "invalid graph model. Use one of the following: $graph_models"
    }
    PartClusManager::set_graph_model $keys(-graph_model)
  } else {
    PartClusManager::set_graph_model "star"
  }

  # Weight model
  if { [info exists keys(-weight_model)] } {
     if { !([string is integer $keys(-weight_model)] && \
             $keys(-weight_model) >= 1 && $keys(-weight_model) <= 7) } {
       ord::error "argument -weight_model should be an integer in the range \[1, 7\]"
     } else {
       PartClusManager::set_weight_model $keys(-weight_model)
     }     
  } else {
    PartClusManager::set_weight_model 1
  }

  # Max edge weight
  if { [info exists keys(-max_edge_weight)] } {
       if { !([string is integer $keys(-max_edge_weight)] && \
              $keys(-max_edge_weight) >= 1 && $keys(-max_edge_weight) <= 32768) } {
      ord::error "argument -max_edge_weight should be an integer in the range \[1, 32768\]"
    } else {
       PartClusManager::set_max_edge_weight $keys(-max_edge_weight)
    }       
  } else {
    PartClusManager::set_max_edge_weight 100
  }

  # Max vertex weight
  if { [info exists keys(-max_vertex_weight)] } {
       if { !([string is integer $keys(-max_vertex_weight)] && \
              $keys(-max_vertex_weight) >= 1 && $keys(-max_vertex_weight) <= 32768) } {
      ord::error "argument -max_vertex_weight should be an integer in the range \[1, 32768\]"
    } else {
       PartClusManager::set_max_vertex_weight $keys(-max_vertex_weight)
    }       
  } else {
    PartClusManager::set_max_vertex_weight 100
  }

  # Num starts
  if { [info exists keys(-num_starts)] } {
       if { !([string is integer $keys(-num_starts)] && \
              $keys(-num_starts) >= 1 && $keys(-num_starts) <= 32768) } {
      ord::error "argument -num_starts should be an integer in the range \[1, 32768\]"
    } else {
       PartClusManager::set_num_starts $keys(-num_starts)
    }       
  }
  
  # Balance constraint
  if { [info exists keys(-balance_constraint)] } {
       if { !([string is integer $keys(-balance_constraint)] && \
              $keys(-balance_constraint) >= 0 && $keys(-balance_constraint) <= 50) } {
      ord::error "argument -balance_constraint should be an integer in the range \[0, 50\]"
    } else {
       PartClusManager::set_balance_constraint $keys(-balance_constraint)
    }       
  } else {
    PartClusManager::set_balance_constraint 2
  }

  # Coarsening ratio 
  if { [info exists keys(-coarsening_ratio)] } {
       if { !([string is double $keys(-coarsening_ratio)] && \
              $keys(-coarsening_ratio) >= 0.5 && $keys(-coarsening_ratio) <= 1.0) } {
      ord::error "argument -coarsening_ratio should be a floating number in the range \[0.5, 1.0\]"
    } else {
       PartClusManager::set_coarsening_ratio $keys(-coarsening_ratio)
    }       
  } else {
    PartClusManager::set_coarsening_ratio 0.7
  }

  # Coarsening vertices
  if { [info exists keys(-coarsening_vertices)] } {
       if { !([string is integer $keys(-coarsening_vertices)]) } {
          ord::error "argument -coarsening_vertices should be an integer"
       } else {
        PartClusManager::set_coarsening_vertices $keys(-coarsening_vertices)
       }
  } else {
    PartClusManager::set_coarsening_vertices 2500
  }

  # Terminal propagation 
  if { [info exists keys(-enable_term_prop)] } {
       if { !([string is integer $keys(-enable_term_prop)] && \
              $keys(-enable_term_prop) >= 0 && $keys(-enable_term_prop) <= 1) } {
          ord::error "argument -enable_term_prop should be 0 or 1"
       } else {
        PartClusManager::set_enable_term_prop $keys(-enable_term_prop)
       }
  } else {
    PartClusManager::set_enable_term_prop 0
  }

  # Cut hop ratio 
  if { [info exists keys(-cut_hop_ratio)] } {
       if { !([string is double $keys(-cut_hop_ratio)] && \
              $keys(-cut_hop_ratio) >= 0.5 && $keys(-cut_hop_ratio) <= 1.0) } {
      ord::error "argument -cut_hop_ratio should be a floating number in the range \[0.5, 1.0\]"
    } else {
       PartClusManager::set_cut_hop_ratio $keys(-cut_hop_ratio)
    }       
  } else {
    PartClusManager::set_cut_hop_ratio 1.0
  }

  # Architecture
  if { [info exists keys(-architecture)] } {
        PartClusManager::set_architecture $keys(-architecture)
  } else {
    PartClusManager::clear_architecture
  }

  # Refinement
  if { [info exists keys(-refinement)] } {
    if { !([string is integer $keys(-refinement)] && \
              $keys(-refinement) >= 0 && $keys(-refinement) <= 32768) } {
      ord::error "argument -refinement should be an integer in the range \[0, 32768\]"
    } else {
        PartClusManager::set_refinement $keys(-refinement)
    }
  } else {
    PartClusManager::set_refinement 0
  }

  # Seeds
  if { [info exists keys(-seeds)] } {
        PartClusManager::set_seeds $keys(-seeds)
  } else {
        if {! [info exists keys(-num_starts)]} {
              ord::error "missing argument -seeds or -num_starts."
        }
        PartClusManager::generate_seeds $keys(-num_starts)
  }


  # Number of partitions
  if { ![info exists keys(-num_partitions)] } {
    ord::error "missing mandatory argument \"-num_partitions \[2, 32768\]\""
  } elseif { !([string is integer $keys(-num_partitions)] && \
              $keys(-num_partitions) >= 2 && $keys(-num_partitions) <= 32768)} {
    ord::error "argument -num_partitions should be an integer in the range \[2, 32768\]"
  } else {
    PartClusManager::set_target_partitions $keys(-num_partitions) 
    if {[expr !(($keys(-num_partitions) & ($keys(-num_partitions) - 1)) == 0)]} {
          PartClusManager::set_architecture "1 $keys(-num_partitions)"
    }
  }

  # Partition Id (for exisisting partitions)
  if { [info exists keys(-partition_id)] } {
        if { !([string is integer $keys(-partition_id)]) } {
          ord::error "argument -partition_id should be an integer"
        } else {
          PartClusManager::set_existing_id $keys(-partition_id)
        }
  } else {
    PartClusManager::set_existing_id -1
  }

  if { [info exists keys(-force_graph)] } {
        PartClusManager::set_force_graph $keys(-force_graph)
  }

  set currentId [PartClusManager::run_partitioning]
  
  return $currentId
}

#--------------------------------------------------------------------
# Evaluate partitioning command
#--------------------------------------------------------------------

sta::define_cmd_args "evaluate_partitioning" { [-partition_ids ids] \
                                               [-evaluation_function function] \
                                             }
proc evaluate_partitioning { args } {
  sta::parse_key_args "evaluate_partitioning" args \
    keys {-partition_ids \
          -evaluation_function \
         } flags {}
    
  # Partition IDs
  if { [info exists keys(-partition_ids)] } {
        PartClusManager::set_partition_ids_to_test $keys(-partition_ids)
  } else {
        ord::error "missing argument -partition_ids."
  }

  # Evaluation Function
  set functions "terminals hyperedges size area runtime hops"
  if { [info exists keys(-evaluation_function)] } {
        if { !($keys(-evaluation_function) in $functions) } {
          ord::error "invalid function. Use one of the following: $functions"
        }
        PartClusManager::set_evaluation_function $keys(-evaluation_function)
  }

  set bestId [PartClusManager::evaluate_partitioning]
  
  return $bestId
}

#--------------------------------------------------------------------
# Write partition to DB command
#--------------------------------------------------------------------

sta::define_cmd_args "write_partitioning_to_db" { [-partitioning_id id] \
                                                  [-dump_to_file name] \
                                                }

proc write_partitioning_to_db { args } {
  sta::parse_key_args "write_partitioning_to_db" args \
    keys { -partitioning_id \
           -dump_to_file \
         } flags { }

  set partitioning_id 0
  if { ![info exists keys(-partitioning_id)] } {
    ord::error "missing mandatory argument -partitioning_id"
  } else {
    set partition_id $keys(-partitioning_id)
  } 
  
  PartClusManager::write_partitioning_to_db $partitioning_id

  if { [info exists keys(-dump_to_file)] } {
    PartClusManager::dump_part_id_to_file $keys(-dump_to_file)
  } 
}

#--------------------------------------------------------------------
# Cluster netlist command
#--------------------------------------------------------------------

sta::define_cmd_args "cluster_netlist" { [-tool name] \
                                         [-coarsening_ratio value] \
                                         [-coarsening_vertices value] \
                                         [-level values] \
                                        }
proc cluster_netlist { args } {
  sta::parse_key_args "cluster_netlist" args \
    keys {-tool \
          -coarsening_ratio \
          -coarsening_vertices \
          -level \
         } flags {}

  # Tool
  set tools "chaco gpmetis mlpart"
  if { ![info exists keys(-tool)] } {
    ord::error "missing mandatory argument -tool"
  } elseif { !($keys(-tool) in $tools) } {
    ord::error "invalid tool. Use one of the following: $tools"
  } else {
     PartClusManager::set_tool $keys(-tool)
  }

  # Coarsening ratio 
  if { [info exists keys(-coarsening_ratio)] } {
       if { !([string is double $keys(-coarsening_ratio)] && \
              $keys(-coarsening_ratio) >= 0.5 && $keys(-coarsening_ratio) <= 1.0) } {
      ord::error "argument -coarsening_ratio should be a floating number in the range \[0.5, 1.0\]"
    } else {
       PartClusManager::set_coarsening_ratio $keys(-coarsening_ratio)
    }       
  }

  # Coarsening vertices
  if { [info exists keys(-coarsening_vertices)] } {
       PartClusManager::set_coarsening_vertices $keys(-coarsening_vertices)
  }

  # Levels
  if { [info exists keys(-level)] } {
        PartClusManager::set_level $keys(-level)
  } else {
        PartClusManager::set_level 1
  }

  PartClusManager::generate_seeds 1

  set currentId [PartClusManager::run_clustering]
  
  return $currentId
}

#--------------------------------------------------------------------
# Write clustering to DB command
#--------------------------------------------------------------------

sta::define_cmd_args "write_clustering_to_db" { [-clustering_id id] \
                                                [-dump_to_file name] \
                                              }

proc write_clustering_to_db { args } {
  sta::parse_key_args "write_clustering_to_db" args \
    keys { -clustering_id \
           -dump_to_file \
         } flags { }

  set clustering_id 0
  if { ![info exists keys(-clustering_id)] } {
    ord::error "missing mandatory argument -clustering_id"
  } else {
    set clustering_id $keys(-clustering_id)
  } 
  
  PartClusManager::write_clustering_to_db $clustering_id

  if { [info exists keys(-dump_to_file)] } {
    PartClusManager::dump_clus_id_to_file $keys(-dump_to_file)
  } 
}

#--------------------------------------------------------------------
# Report netlist partitions command
#--------------------------------------------------------------------

sta::define_cmd_args "report_netlist_partitions" { [-partitioning_id id] \
                                                 }

proc report_netlist_partitions { args } {
  sta::parse_key_args "report_netlist_partitions" args \
    keys { -partitioning_id \
         } flags { }

  set partitioning_id 0
  if { ![info exists keys(-partitioning_id)] } {
    ord::error "missing mandatory argument -partitioning_id"
  } else {
    set partitioning_id $keys(-partitioning_id)
  } 
  
  PartClusManager::report_netlist_partitions $partitioning_id
}

sta::define_cmd_args "read_partitioning" { [-read_file name] \
					   [-final_partitions] \
					 }

proc read_partitioning { args } {
	sta::parse_key_args "read_partitioning" args \
	keys { -read_file \
	       -final_partitions \
	} flags { }

    		PartClusManager::set_final_partitions $keys(-final_partitions) 
	if { ![info exists keys(-read_file)] } {
    		ord::error "missing mandatory argument -read_file"
  	} else {
  		PartClusManager::read_file $keys(-read_file)
  	} 
  

  	if { ![info exists keys(-final_partitions)] } {
    		ord::error "missing mandatory argument \"-final_partitions \[2, 32768\]\""
  	} else {
	}
}
