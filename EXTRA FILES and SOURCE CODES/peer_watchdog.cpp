#include <iostream>
#include <unistd.h>
#include <cstdlib>
#include <string>
#include <cstdarg>
#include <fstream>
#include <memory>
#include <cstdio>



// g++ /home/fabric/pull_tests/data/peer/peer_watchdog.cpp -o /home/fabric/pull_tests/data/peer/peer_watchdog
// ./peer_watchdog &>/dev/null &

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


int main(int argc, char* argv[]) {
  
  std::string get_peer_block_id;
  
   while (true) {
   
   	  get_peer_block_id = exec("pidof peer_block");
      if (get_peer_block_id.size() == 0)
        system("./peer_block &>/dev/null &");
        
      sleep(17);
   }


	return 0;
}
