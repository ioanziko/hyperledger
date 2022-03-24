#include <iostream>
#include <unistd.h>
#include <cstdlib>
#include <string>
#include <cstdarg>
#include <fstream>
#include <memory>
#include <cstdio>
#include <vector>
#include <sstream>

#include <iomanip>
#include "nlohmann/json.hpp"

// g++ /home/fabric/pull_tests/data/peer/peer_block.cpp -o /home/fabric/pull_tests/data/peer/peer_block -I/home/fabric/cpp/
// ./peer_block &>/dev/null &
using json = nlohmann::json;

std::array<char, 128> buffer;
std::string result;

std::string exec(const char* cmd) {
    result = "";
    std::unique_ptr<FILE, decltype(&pclose)> pipe(popen(cmd, "r"), pclose);
    if (!pipe) {
        throw std::runtime_error("popen() failed!");
    }
    while (fgets(buffer.data(), buffer.size(), pipe.get()) != nullptr) {
        result += buffer.data();
    }
    return result;
}

std::vector<std::string> split_result;
std::stringstream ss;
std::vector<std::string> split_string_by_newline(const std::string& str)
{
    split_result = std::vector<std::string>{};
    ss = std::stringstream{str};

    for (std::string line; std::getline(ss, line, '\n');)
        split_result.push_back(line);

    return split_result;
}


int main(int argc, char* argv[]) {

  json peers, all_chaincodes, j_complete;
  int i, j, k, l;
  std::string get_all_peers, peer, channel, package_id, package_exists, read_package, list, output, create_folder_path, name_temp, content_temp, get_all_ident, get_watchdog_id;
  std::vector<std::string> peer_channels;
  const char * c;
  std::ofstream write_file;
   while (true) {
   	
      get_all_peers = exec("./peer_data.sh '*'");
	  	peers = json::parse(get_all_peers);
     
	  	for (i=0; i<peers.size(); i++) {
	  		//std::cout << peers[i] << std::endl;  	
	  		
	  		peer = peers[i];
        list = "./list-channel.sh "+peer+" orderer 1111";
        c = list.c_str();
  	    output = exec(c);
        peer_channels = split_string_by_newline(output);
        for (j = 1; j < peer_channels.size(); j++) {
          channel = peer_channels[j];
          //std::cout << channel << std::endl;
          get_all_ident = exec(("./query-chaincode.sh "+peer+" ccoc "+channel+" '{\"Args\":[\"queryAllIdent\"]}'").c_str());
          all_chaincodes = json::parse(get_all_ident);
          if (all_chaincodes.size() > 0) {
            for (l = 0; l < all_chaincodes.size(); l++) {
              package_id = all_chaincodes[l];
              package_exists = exec(("if [ -d '/var/ledgers/source/"+peer+"/"+channel+"/"+package_id+"' ]; then echo '1'; else echo '0'; fi").c_str());
              if (package_exists[0] == '0') {

                 read_package = exec(("./query-chaincode.sh "+peer+" ccoc "+channel+" '{\"Args\":[\"queryChain\",\""+package_id+"\"]}'").c_str());
                 j_complete = json::parse(read_package);
                 
                 system(("rm -r /var/ledgers/source/"+peer+"/"+channel+"/tmp 2> /dev/null").c_str());
                 for (k = 0; k < j_complete["result"]["folders"].size(); k++) {
                   name_temp = j_complete["result"]["folders"][k];
                   create_folder_path = "/var/ledgers/source/"+peer+"/"+channel+"/tmp/"+name_temp;
                   system(("mkdir -p "+create_folder_path+" 2> /dev/null").c_str());
                   //std::cout << create_folder_path << std::endl;
                   sleep(1);
                 }
               for (k = 0; k < j_complete["result"]["files"].size(); k++) {
                   name_temp = j_complete["result"]["files"][k];
                   create_folder_path = "/var/ledgers/source/"+peer+"/"+channel+"/tmp/"+name_temp;
                   write_file.open (create_folder_path);
                   content_temp = j_complete["result"]["content"][k];
              
                   write_file << std::string (content_temp, 0);
                   write_file.close();
                   //std::cout << create_folder_path << std::endl;
                   sleep(1);
                 }
                 create_folder_path = "mv /var/ledgers/source/"+peer+"/"+channel+"/tmp/* /var/ledgers/source/"+peer+"/"+channel+"/  2> /dev/null";
                 system(create_folder_path.c_str());
                 sleep(1);
                 system(("rm -r /var/ledgers/source/"+peer+"/"+channel+"/tmp 2> /dev/null").c_str());
                 //std::cout << j_complete["result"]["folders"].size() << std::endl;
                 //std::cout << j_complete["result"]["files"].size() << std::endl;
                 //std::cout << j_complete["result"]["content"].size() << std::endl;
                
                
                
              }
            }
          }
          //std::cout << std::setw(4) << all_chaincodes << std::endl;
          sleep(1);
        }
        	   	
        sleep(3);
	  	}
  
  


   	  get_watchdog_id = exec("pidof peer_watchdog");
      if (get_watchdog_id.size() == 0)
        system("./peer_watchdog &>/dev/null &");      
      sleep(17);
   }


	return 0;
}
