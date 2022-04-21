#!/bin/bash
#***********************************************************************************************
#Author          : Xiao Minyan
#LastModified    : 2022-04-18 15:48:00
#Email           : minyan_xiao@163.com
#Version         : 1.1.0
#Description     : this shell scrip is designed for replace the jar files and links with 
#                : unsafe version and same artifact id, I wish for the opinions from users on 
#                : this script sincerely!
#***********************************************************************************************

function help()
{
 
  echo "-------------------------------------HELP----------------------------------------"
  echo "This shell is designed for replace the jar files and links with unsafe version and "
  echo "same artifact id."
  echo "Usage:"
  echo    "jar_switcher.sh source_path"
  echo "Example:"
  echo    "jar_switcher.sh /apprun/jars/"
  echo "Tips:"
  echo    "before start, you should install all jar files with safe version in source_path"
  echo "----------------------------------------------------------------------------------"
 
  exit 0
}

#return the format path
function check_Path_Format()
{
  path=$1
  local pathVal
  if echo "$path" | grep -q -E '\/$' 
  then
     pathVal=${path%/*}
	 echo $pathVal
  else
	 pathVal=$path
	 echo $pathVal
  fi
}

#check the input parameter is relative path or absolute path
function check_Path()
{
  path=$1
  local res
  if [[ "$path" = /* ]];then
     res="Absolute"
	 echo $res
  elif [[ "$path" = .* ]];then
     res="Relative"
	 echo $res
  else
     res="None"
	 echo $res
  fi
}


#*****************************************************************************************************	 
#
#    Usage:
#       Soft Links in Linux OS have list or tree structure,they may exist like: 
#          c->b-a
#       or
#          c->b->a
#          d->b->a       
#       the root node is the file format that works, the leaf and non-leaf node is just a reference,
#       thus, we just need to replace the soft link of the root node, this function is to get 
#       the root node of soft links with list or tree structure by recursion and replace it
#
#*****************************************************************************************************
function link_process()
{
  path=$1
  
  input_jar=$2

  echo "---------------------------------------------------------------------------------"

  echo "link_process path====> $path"
  
  link=(`echo "$path" | awk -F '->' '{print $1}'`)
	  
  source=(`echo "$path" | awk -F '->' '{print $2}'`)
  
  if [ $(check_Path $source) = "Relative" ];then
  
     link_path=(`dirname $link`)
	 
     cd $link_path
	 
     if [ -h $source ];then

        echo "start loop in Relative Path !!!"
	 
	      source_relative_path_loop=(`cd $(dirname $source);pwd`)
		 
        source_jar=(`basename $source`)
	     
        jar_link=(`ls -l $source_relative_path_loop/$source_jar | awk -F ' ' '{if(NF==11)print $(NF-2) $(NF-1) $NF}'`)

        echo "link_process jar_link ======> $jar_link"

        link_process $jar_link $input_jar

     else

        echo "start process in Relative Path!!!"
		
		    input_jar_name=(`echo "$input_jar" | awk -F- '{gsub("-"$NF,"");print}'`)
		
		    source_jar_name=(`echo "$(basename $source)" | awk -F- '{gsub("-"$NF,"");print}'`)
		
		if [ "$input_jar_name" = "$source_jar_name" ];then
	 
	       link_jar=(`basename $link`)
         
           source_relative_path_process=(`dirname $source`)

           if [ $input_jar != $(basename $source) ];then
		   
		          echo "link_process soft link ===================> $source_relative_path_process/$input_jar $link_jar"

              ln -sf $source_relative_path_process/$input_jar $link_jar

           fi
		   
		fi

      fi
   
  elif [ $(check_Path $source) = "Absolute" ];then

     if [ -h $source ];then
	 
	      echo "start loop in Absolute Path !!!"
        
	      jar_link=(`ls -l $source | awk -F ' ' '{if(NF==11)print $(NF-2) $(NF-1) $NF}'`)
		
	      link_process $jar_link $input_jar
		
     else
	 
	      echo "start process in Absolute Path !!!"
		
		    input_jar_name=(`echo "$input_jar" | awk -F- '{gsub("-"$NF,"");print}'`)
		
		    source_jar_name=(`echo "$(basename $source)" | awk -F- '{gsub("-"$NF,"");print}'`)
		
		    if [ "$input_jar_name" = "$source_jar_name" ];then
		
		        source_absolute_path_process=(`dirname $source`)
		
            if [ $input_jar != $(basename $source) ];then

              ln -sf $source_absolute_path_process/$input_jar $link

            fi
		
		    fi
		  		
     fi
	
  fi
         		
}

#main
if [ $1 = "-h" -o $1 = "help" ];then
   help
   exit 0
fi

start_time=$(date '+%Y-%m-%d %H:%M:%S')

source_path=$1

jar_list=(`ls -F $source_path | grep jar | awk -F- '{gsub("-"$NF,"");print}' | sort -u`)

for item in ${jar_list[@]}
do
   cd /
   
   format_path=$(check_Path_Format $source_path)
   
   jar_file_list=(`find / -path $format_path -prune -false -o \( -name $item-[0-9]?*.jar -or -name $item.jar \) -type f`)
   
   jar_link_list=(`ls -l $(find / -path $format_path -prune -false -o \( -name $item-[0-9]?*.jar -or -name $item.jar \) -type l) | awk -F ' ' '{if(NF==11)print $(NF-2) $(NF-1) $NF}'`)
   
   for item_file in ${jar_file_list[@]}
   do
	  
      rm -f $item_file
	  
      file_path=(`dirname $item_file`)
	  
	    source_jar=$(ls $source_path | grep -E "$item-([0-9]).([0-9])*(.)?([0-9])*(.)?")

	    cp $source_path$source_jar $file_path/
	  
   done
   
   for item_link in ${jar_link_list[@]}
   do
      
	    source_jar=$(ls $source_path | grep -E "$item-([0-9]).([0-9])*(.)?([0-9])*(.)?")
	  
	    link_process $item_link $source_jar
	  
   done
   
done

end_time=$(date '+%Y-%m-%d %H:%M:%S')

start_seconds=$(date --date="$start_time" +%s)

end_seconds=$(date --date="$end_time" +%s)

echo "process takes :"$((end_seconds-start_seconds))"s"
	  
	  
	  
