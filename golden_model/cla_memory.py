class MemoryRegion:
    def __init__(self , name , start ,size_word ,read ,write , executable , cpu_read = True , cpu_write = True):
            self.name = name
            self.start = start
            self.size_word = size_word
            self.read = read              # CLA okuma izni
            self.write = write            # CLA yazma izni
            self.cpu_read = cpu_read      # CPU okuma izni
            self.cpu_write = cpu_write    # CPU yazma izni
            self.executable = executable
            self.words = [0]*size_word


class ClaMemory:

   

      def __init__(self):
        # Donanımsal bellek haritası sabit olarak içeride tanımlanır
        self.regions = [
            MemoryRegion(
                "CLAtoCPU_Msg",
                0x001480,
                128,
                read=True,
                write=True,
                executable=False,
                cpu_read=True,
                cpu_write=False,
            ),
            MemoryRegion(
                "CPUtoCLA_Msg",
                0x001500,
                128,
                read=True,
                write=False,
                executable=False,
                cpu_read=True,
                cpu_write=True,
            ),
            MemoryRegion(
                "L1_Data", 0x008800, 1024, read=True, write=True, executable=False,
                cpu_read=False, cpu_write=False
            ),
            MemoryRegion(
                "L2_Data", 0x008C00, 1024, read=True, write=True, executable=False,
                cpu_read=False, cpu_write=False
            ),
            MemoryRegion(
                "L3_Prog", 0x009000, 4096, read=False, write=False, executable=True,
                cpu_read=False, cpu_write=False
            ),
        ]
        self.write_log = []  # İz toplayıcı (Trace Collector)
        self.ignored_writes = 0       # donanimin sessizce yuttugu yazma sayisi
        self.unaligned_accesses = 0   # tek adresli 32-bit erisim sayisi (s.568)

      def _can_read(self, region, who):
                if who == "cla":
                    return region.read
                return region.cpu_read

      def _can_write(self, region, who):
                if who == "cla":
                    return region.write
                return region.cpu_write

      def region_of(self, addr: int):
                # CLAtoCPU Message RAM (128 words)
                if 0x001480 <= addr <= 0x0014FF:
                    return self.regions[0]

                # CPUtoCLA Message RAM (128 words)
                elif 0x001500 <= addr <= 0x00157F:
                    return self.regions[1]

                # L1 Veri RAM (1024 words)
                elif 0x008800 <= addr <= 0x008BFF:
                    return self.regions[2]

                # L2 Veri RAM (1024 words: 0x8C00 - 0x8FFF)
                elif 0x008C00 <= addr <= 0x008FFF:
                    return self.regions[3]

                # L3 Program RAM (4096 words: 0x9000 - 0x9FFF)
                elif 0x009000 <= addr <= 0x009FFF:
                    return self.regions[4]

                # Aradaki boşluklar veya harita dışındaki tüm adresler
                else:
                    raise ValueError(f"Tanımsız veya erişilemez bellek adresi: {hex(addr)}")
                            
            #who = cpu senaryosu ıcın ne yapılması gerektıgıne goz at !
      def read16(self , addr , who = "cla"):
                region = self.region_of(addr)
                if(self._can_read(region, who)):
                      return region.words[addr-region.start]&0xFFFF

                else:
                      return 0


      def write16(self , addr, value, who="cla"):
             value = value&0xFFFF
             region = self.region_of(addr)
             if(self._can_write(region, who)):
                    region.words[addr-region.start] = value
                    self.write_log.append((addr, value & 0xFFFF, 16))
                    return True

             self.ignored_writes += 1
             return False
            
                            
      def read32(self , addr, who="cla"):
                   if(addr % 2 != 0):
                        self.unaligned_accesses += 1
                        addr = addr-1

                   region = self.region_of(addr)
                   if(self._can_read(region, who)):
                         return ( region.words[addr-region.start+1] << 16 | region.words[addr-region.start]) &0xFFFFFFFF

                   else:
                         return 0 
                
                 
      def write32(self , addr, value, who="cla"):

                    if(addr % 2 != 0):
                            self.unaligned_accesses += 1
                            addr = addr-1

                    value = value&0xFFFFFFFF
                    region = self.region_of(addr)
                    if(self._can_write(region, who)):
                          region.words[addr-region.start] = value&0xFFFF
                          region.words[addr-region.start+1 ] = value>>16 & 0xFFFF
                          self.write_log.append((addr, value & 0xFFFFFFFF, 32))
                          return True
      
                    self.ignored_writes += 1
                    return False


      def fetch32(self, mpc):
                
                if mpc % 2 != 0:
                    self.unaligned_accesses += 1
                    mpc = mpc - 1

                
                # Bölgeyi değişkene alıp doğrudan kullanıyoruz
                region = self.regions[4]
                addr = region.start + mpc
                
                if not region.executable:
                    raise PermissionError(
                        f"Tanımsız veya erişilemez bellek adresi: {hex(addr)}"
                    )

                # Sinir kontrolu: Python negatif indekslemede SESSIZCE dizinin
                # sonundan okur. fetch32(-2) hata vermeden L3'un son komutunu
                # dondururdu. MPC 12 bite maskeli oldugu icin bugun erisilemez
                # ama MVECT yuklemesi mpc'ye dogrudan atama yapacak (Faz 6).
                if not 0 <= mpc < region.size_word - 1:
                    raise ValueError(
                        f"MPC L3 disinda: {mpc} (gecerli araligi 0-{region.size_word-2})"
                    )

                MSW = region.words[mpc+1] << 16
                LSW = region.words[mpc ]
                instruction = MSW | LSW
                return instruction

      def load_program(self, words, start_index = 0 ):
              region = self.regions[4]
              if start_index + len(words)*2 > region.size_word:
                     
                     raise ValueError("Program boyutu L3 RAM kapasitesini aşıyor!")
              
              for word in words:
                                       
                     region.words[start_index] = word&0xFFFF
                     region.words[start_index+1] = word>>16&0xFFFF
                     start_index += 2