
#--------------------------------------------------------------------
# Name: create_model_formula.R
# Inputs: model_info "RData file name" and list_of variables "RData file names" 
# outputs: the model formula
#--------------------------------------------------------------------
#
# test code:
#
#
# > t1=c("list_of_variables.RData")
# > t2=c("model_info.RData")
# > model_predictor = create_formula(t2,t1)
# > model_predictor
# [1] "Y ~ famhist + as.factor(menarche_dec) + as.factor(parity) + as.factor(birth_dec) + 
#      as.factor(agemeno_dec) + as.factor(height_dec) + as.factor(bmi_dec) + as.factor(rd_menohrt) + 
#      rd2_everhrt_e + rd2_everhrt_c + rd2_currhrt + as.factor(alcoholdweek_dec) + 
#      as.factor(ever_smoke) + as.factor(bmi_dec)*as.factor(rd_menohrt)"
#
# > save(model_predictor, file="model_predictor.RData")
#----------------------------------------------------------------------


create_formula <- function(model_info_RData, list_of_variables_RData){
  
  model_info=get(load(model_info_RData))
  list_of_variables=get(load(list_of_variables_RData))
  
  # initialize
  form = "Y ~ "
  inter = " "
  # add linear terms, collect interactions
  for(i in 1:length(model_info)){
    
    if(model_info[[i]]$linear){
      if(i!=1){
        form = paste(form, " + ", sep="")
      }    
      if(list_of_variables[[i]]$type=="factor"){
        form = paste(form, "as.factor(", model_info[[i]]$name ,")", sep="")
        if(!is.null(model_info[[i]]$interaction)){
          for(j in 1:length(model_info[[i]]$interaction)){
            inter = paste(inter, "+ as.factor(", model_info[[i]]$name ,")*", sep="")
            inter = paste(inter, form_type(model_info[[i]]$interaction[j], model_info, list_of_variables), sep="")
          }
        }
      }else{
        form = paste(form, model_info[[i]]$name , sep="")
        if(!is.null(model_info[[i]]$interaction)){
          for(j in 1:length(model_info[[i]]$interaction)){
          inter = paste(inter,"+ " , model_info[[i]]$name , "*", sep="")
          inter = paste(inter, form_type(model_info[[i]]$interaction[j], model_info, list_of_variables), sep="")
          }
        }
      }
    }
  }
  # add interaction terms
  form = paste(form, inter, sep="")
  return (form)
}

form_type<-function(var_name, model_info, list_of_variables){
  
  for(j in 1:length(list_of_variables)){
    if(var_name == list_of_variables[[j]]$name){
      i = j; break
    }
  }
  if(list_of_variables[[i]]$type=="factor"){
    res = paste("as.factor(", model_info[[i]]$name ,")", sep="")
  }else{
    res = model_info[[i]]$name 
  }
  res
}

