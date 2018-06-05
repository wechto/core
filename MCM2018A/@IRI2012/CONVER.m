function [ rgma ] = CONVER( rga,rgo )
%CONVER converts a geographic latitude and longitude
% location to a corrected geomagnetic latitude
%----------------------STORM MODEL --------------------------------
%
%      SUBROUTINE CONVER(rga,rgo,rgma)
%
%     This subroutine converts a geographic latitude and longitude
%     location to a corrected geomagnetic latitude.
%
%     INPUT: 
%       geographic latitude   -90. to +90.
%       geographic longitude  0. to 360. positive east from Greenwich.
%
%     OUTPUT:
%       corrected geomagnetic latitude	-90. to +90.
  persistent CORMAG NI NJ fI fJ;
  if isempty(CORMAG)
    NI = 20;
    NJ = 91;
    %DIMENSION CORMAG(20,91)      
    %DATA ((CORMAG(i,j),i=1,20),j=1,31)/
    dat1 = [ ...
     +163.68,163.68,163.68,163.68,163.68,163.68, ...
     +163.68,163.68,163.68,163.68,163.68,163.68,163.68,163.68, ...
     +163.68,163.68,163.68,163.68,163.68,163.68,162.60,163.12, ...
     +163.64,164.18,164.54,164.90,165.16,165.66,166.00,165.86, ...
     +165.20,164.38,163.66,162.94,162.42,162.00,161.70,161.70, ...
     +161.80,162.14,161.20,162.18,163.26,164.44,165.62,166.60, ...
     +167.42,167.80,167.38,166.82,166.00,164.66,163.26,162.16, ...
     +161.18,160.40,159.94,159.80,159.98,160.44,159.80,161.14, ...
     +162.70,164.50,166.26,167.90,169.18,169.72,169.36,168.24, ...
     +166.70,164.80,162.90,161.18,159.74,158.60,157.94,157.80, ...
     +157.98,158.72,158.40,160.10,162.02,164.28,166.64,169.00, ...
     +170.80,171.72,171.06,169.46,167.10,164.64,162.18,160.02, ...
     +158.20,156.80,156.04,155.80,156.16,157.02,157.00,158.96, ...
     +161.24,163.86,166.72,169.80,172.42,173.72,172.82,170.34, ...
     +167.30,164.22,161.34,158.74,156.60,155.00,154.08,153.90, ...
     +154.36,155.36,155.50,157.72,160.36,163.32,166.60,170.20, ...
     +173.70,175.64,174.18,170.80,167.10,163.56,160.24,157.36, ...
     +154.96,153.10,152.08,151.92,152.46,153.76,154.10,156.52, ...
     +159.36,162.52,166.24,170.30,174.62,177.48,175.04,170.82, ...
     +166.60,162.70,159.02,155.88,153.22,151.20,150.08,149.92, ...
     +150.64,152.20,152.80,155.32,158.28,161.70,165.58,170.00, ...
     +174.84,178.46,175.18,170.38,165.80,161.64,157.80,154.38, ...
     +151.52,149.30,148.18,148.02,148.92,150.60,151.40,154.08, ...
     +157.18,160.68,164.78,169.40,174.34,177.44,174.28,169.44, ...
     +164.70,160.34,156.30,152.78,149.72,147.40,146.18,146.04, ...
     +147.12,149.04,150.10,152.88,156.00,159.58,163.78,168.50, ...
     +173.28,175.60,172.86,168.14,163.40,158.98,154.88,151.10, ...
     +147.98,145.50,144.18,144.14,145.40,147.48,148.80,151.68, ...
     +154.88,158.48,162.68,167.40,171.76,173.60,171.12,166.68, ...
     +162.00,157.48,153.28,149.50,146.18,143.50,142.18,142.24, ...
     +143.68,145.98,147.50,150.54,153.68,157.28,161.42,166.10, ...
     +170.10,171.48,169.22,164.98,160.40,155.88,151.68,147.80, ...
     +144.34,141.60,140.18,140.26,141.98,144.62,146.30,149.34, ...
     +152.48,155.98,160.08,164.60,168.34,169.38,167.20,163.18, ...
     +158.60,154.18,149.98,146.02,142.54,139.70,138.18,138.46, ...
     +140.26,143.16,145.10,148.14,151.18,154.60,158.68,163.10, ...
     +166.48,167.28,165.18,161.32,156.90,152.48,148.28,144.32, ...
     +140.74,137.80,136.22,136.48,138.64,141.76,143.90,146.98, ...
     +149.98,153.30,157.24,161.40,164.52,165.16,162.86,159.42, ...
     +155.00,150.68,146.48,142.52,138.94,135.90,134.22,134.68, ...
     +137.02,140.40,142.70,145.84,148.76,151.92,155.74,159.70, ...
     +162.52,162.96,160.98,157.42,153.10,148.84,144.68,140.82, ...
     +137.20,134.00,132.32,132.80,135.42,139.10,141.60,144.74, ...
     +147.46,150.52,154.20,158.00,160.46,160.76,158.86,155.36, ...
     +151.20,146.94,142.88,139.02,135.40,132.10,130.32,131.00, ...
     +133.80,137.74,140.50,143.58,146.24,149.12,152.60,156.20, ...
     +158.40,158.66,156.76,153.36,149.30,145.04,141.08,137.30, ...
     +133.60,130.30,128.42,129.12,132.28,136.44,139.30,142.48, ...
     +144.94,147.64,150.48,154.30,156.34,156.36,154.56,151.26, ...
     +147.30,143.14,139.20,135.50,131.90,128.40,126.52,127.32, ...
     +130.76,135.18,138.20,141.28,143.72,146.24,149.26,152.40, ...
     +154.24,154.16,152.36,149.16,145.30,141.24,137.30,133.70, ...
     +130.10,126.60,124.62,125.54,129.16,133.92,137.10,140.18, ...
     +142.42,144.66,147.62,150.50,152.18,151.96,150.16,147.10, ...
     +143.30,139.24,135.50,131.90,128.36,124.80,122.72,123.74, ...
     +127.64,132.62,135.90,139.02,141.12,143.18,145.92,148.60, ...
     +149.98,149.76,148.04,145.00,141.20,137.30,133.60,130.10, ...
     +126.60,123.00,120.86,121.96,126.12,131.36,134.80,137.88, ...
     +139.80,141.68,144.08,146.60,147.88,147.56,145.84,142.90, ...
     +139.20,135.30,131.70,128.28,124.86,121.30,118.96,120.18, ...
     +124.70,130.16,133.60,136.72,138.48,140.10,142.38,144.60, ...
     +145.72,145.34,143.64,140.80,137.10,133.30,129.72,126.48, ...
     +123.10,119.50,117.16,118.48,123.18,128.86,132.40,135.42, ...
     +137.08,138.50,140.54,142.60,143.52,143.06,141.44,138.70, ...
     +135.10,131.30,127.82,124.58,121.40,117.70,115.26,116.70, ...
     +121.66,127.60,131.20,134.22,135.66,136.82,138.70,140.60, ...
     +141.36,140.86,139.24,136.50,133.00,129.30,125.92,122.78, ...
     +119.60,116.00,113.40,114.92,120.16,126.30,130.00,132.92, ...
     +134.24,135.14,136.80,138.60,139.16,138.64,137.12,134.40, ...
     +130.90,127.20,123.92,120.96,117.90,114.20,111.56,113.12, ...
     +118.64,124.90,128.70,131.56,132.74,133.44,134.90,136.50, ...
     +137.00,136.36,134.82,132.30,128.70,125.16,121.94,119.06, ...
     +116.10,112.50,109.70,111.42,117.14,123.60,127.30,130.16, ...
     +131.22,131.66,133.00,134.50,134.80,134.14,132.62,130.14, ...
     +126.60,123.06,119.94,117.16,114.30,110.70,107.80,109.64, ...
     +115.62,122.24,125.90,128.76,129.62,129.96,131.06,132.40, ...
     +132.60,131.86,130.42,128.00,124.50,120.96,117.96,115.26, ...
     +112.54,108.90,105.94,107.86,114.02,120.84];

      %DATA ((CORMAG(i,j),i=1,20),j=32,61)/
    dat2 = [ ...
     +124.05,126.79, ...
     +127.55,127.83,128.90,130.21,130.41,129.71,128.33,125.96, ...
     +122.49,118.96,115.97,113.26,110.52,106.89,104.01,106.00, ...
     +112.21,119.06,122.19,124.82,125.48,125.69,126.73,128.03, ...
     +128.22,127.55,126.23,123.92,120.47,116.97,113.97,111.26, ...
     +108.50,104.89,102.08,104.14,110.41,117.29,120.34,122.85, ...
     +123.40,123.56,124.57,125.84,126.03,125.40,124.14,121.88, ...
     +118.46,114.97,111.98,109.26,106.48,102.88,100.15,102.28, ...
     +108.60,115.51,118.49,120.88,121.33,121.42,122.40,123.65, ...
     +123.84,123.24,122.04,119.83,116.45,112.97,109.98,107.26, ...
     +104.46,100.87,098.22,100.42,106.79,113.74,116.63,118.91, ...
     +119.26,119.29,120.24,121.47,121.65,121.09,119.95,117.79, ...
     +114.43,110.98,107.99,105.26,102.44,098.87,096.29,098.56, ...
     +104.98,111.96,114.78,116.94,117.19,117.15,118.07,119.28, ...
     +119.46,118.93,117.86,115.75,112.42,108.98,106.00,103.26, ...
     +100.42,096.86,094.36,096.70,103.18,110.19,112.93,114.97, ...
     +115.12,115.02,115.91,117.09,117.27,116.78,115.76,113.71, ...
     +110.41,106.98,104.00,101.26,098.40,094.85,092.43,094.84, ...
     +101.37,108.41,111.07,113.00,113.04,112.88,113.74,114.91, ...
     +115.08,114.62,113.67,111.67,108.39,104.99,102.01,099.26, ...
     +096.38,092.85,090.51,092.97,099.56,106.64,109.22,111.03, ...
     +110.97,110.75,111.58,112.72,112.89,112.47,111.57,109.63, ...
     +106.38,102.99,100.01,097.26,094.36,090.84,088.58,091.11, ...
     +097.75,104.86,107.37,109.06,108.90,108.61,109.41,110.53, ...
     +110.70,110.31,109.48,107.59,104.37,100.99,098.02,095.26, ...
     +092.34,088.83,086.65,089.25,095.95,103.09,105.51,107.09, ...
     +106.83,106.48,107.25,108.35,108.51,108.16,107.39,105.55, ...
     +102.35,099.00,096.03,093.26,090.32,086.83,084.72,087.39, ...
     +094.14,101.31,103.66,105.12,104.76,104.34,105.08,106.16, ...
     +106.32,106.00,105.29,103.50,100.34,097.00,094.03,091.26, ...
     +088.30,084.82,082.79,085.53,092.33,099.54,101.81,103.15, ...
     +102.68,102.21,102.92,103.97,104.13,103.85,103.20,101.46, ...
     +098.33,095.00,092.04,089.26,086.28,082.81,080.86,083.67, ...
     +090.52,097.76,099.95,101.18,100.61,100.07,100.75,101.79, ...
     +101.94,101.69,101.10,099.42,096.31,093.01,090.04,087.26, ...
     +084.26,080.81,078.93,081.81,088.72,095.99,098.10,099.21, ...
     +098.54,097.94,098.59,099.60,099.75,099.54,099.01,097.38, ...
     +094.30,091.01,088.05,085.26,082.24,078.80,077.00,079.95, ...
     +086.91,094.21,096.25,097.24,096.47,095.81,096.43,097.41, ...
     +097.56,097.39,096.92,095.34,092.29,089.01,086.06,083.26, ...
     +080.22,076.79,075.07,078.09,085.10,092.43,094.39,095.27, ...
     +094.40,093.67,094.26,095.23,095.37,095.23,094.82,093.30, ...
     +090.27,087.02,084.06,081.26,078.20,074.79,073.14,076.23, ...
     +083.30,090.66,092.54,093.30,092.32,091.54,092.10,093.04, ...
     +093.18,093.08,092.73,091.26,088.26,085.02,082.07,079.26, ...
     +076.18,072.78,071.21,074.37,081.49,088.88,090.69,091.33, ...
     +090.25,089.40,089.93,090.85,090.99,090.92,090.63,089.21, ...
     +086.25,083.02,080.07,077.26,074.16,070.77,069.28,072.51, ...
     +079.68,087.11,088.83,089.36,088.18,087.27,087.77,088.67, ...
     +088.80,088.77,088.54,087.17,084.23,081.03,078.08,075.26, ...
     +072.14,068.77,067.35,070.65,077.87,085.33,086.98,087.39, ...
     +086.11,085.13,085.60,086.48,086.61,086.61,086.45,085.13, ...
     +082.22,079.03,076.09,073.26,070.12,066.76,065.42,068.79, ...
     +076.07,083.56,085.13,085.42,084.04,083.00,083.44,084.29, ...
     +084.42,084.46,084.35,083.09,080.21,077.03,074.09,071.26, ...
     +068.10,064.75,063.49,066.93,074.26,081.78,083.27,083.45, ...
     +081.96,080.86,081.27,082.11,082.23,082.30,082.26,081.05, ...
     +078.19,075.04,072.10,069.26,066.08,062.75,061.57,065.06, ...
     +072.45,080.01,081.42,081.48,079.89,078.73,079.11,079.92, ...
     +080.04,080.15,080.16,079.01,076.18,073.04,070.10,067.26, ...
     +064.06,060.74,059.64,063.20,070.64,078.23,079.57,079.51, ...
     +077.82,076.59,076.94,077.73,077.85,077.99,078.07,076.97, ...
     +074.17,071.04,068.11,065.26,062.04,058.73,057.71,061.34, ...
     +068.84,076.46,077.71,077.54,075.75,074.46,074.78,075.55, ...
     +075.66,075.84,075.98,074.93,072.15,069.05,066.12,063.26, ...
     +060.02,056.73,055.78,059.48,067.03,074.68,075.86,075.57, ...
     +073.68,072.32,072.61,073.36,073.47,073.68,073.88,072.88, ...
     +070.14,067.05,064.12,061.26,058.00,054.72,053.85,057.62, ...
     +065.22,072.91,074.01,073.60,071.60,070.19,070.45,071.17, ...
     +071.28,071.53,071.79,070.84,068.13,065.05,062.13,059.26, ...
     +055.98,052.71,051.92,055.76,063.41,071.13,072.15,071.63, ...
     +069.53,068.05,068.28,068.99,069.09,069.37,069.69,068.80, ...
     +066.11,063.06,060.13,057.26,053.96,050.71,049.99,053.90, ...
     +061.61,069.36,070.30,069.66,067.46,065.92,066.12,066.80, ...
     +066.90,067.22,067.60,066.76,064.10,061.06,058.14,055.26, ...
     +051.94,048.70,048.06,052.04,059.80,067.58];

     % DATA ((CORMAG(i,j),i=1,20),j=62,91)/
    dat3 = [ ...
     +067.70,067.06, ...
     +065.08,063.72,063.98,064.60,064.80,065.12,065.60,064.86, ...
     +062.40,059.26,056.24,053.18,049.84,046.60,046.12,050.12, ...
     +057.52,064.80,064.90,064.42,062.70,061.62,061.78,062.40, ...
     +062.60,063.04,063.58,063.00,060.60,057.46,054.42,051.18, ...
     +047.70,044.60,044.22,048.02,055.06,061.92,062.10,061.72, ...
     +060.32,059.50,059.68,060.20,060.46,060.94,061.58,061.00, ...
     +058.70,055.66,052.52,049.18,045.60,042.50,042.22,046.00, ...
     +052.60,058.98,059.20,059.18,058.12,057.32,057.48,058.00, ...
     +058.30,058.84,059.48,059.04,056.90,053.86,050.62,047.10, ...
     +043.50,040.50,040.28,043.98,050.22,056.18,056.40,056.64, ...
     +055.84,055.20,055.38,055.80,056.16,056.84,057.48,057.04, ...
     +055.10,052.06,048.70,045.10,041.40,038.40,038.28,041.88, ...
     +047.94,053.44,053.70,054.14,053.56,053.10,053.24,053.70, ...
     +054.06,054.74,055.38,055.14,053.20,050.26,046.80,043.10, ...
     +039.34,036.40,036.38,039.96,045.56,050.84,051.10,051.70, ...
     +051.36,051.00,051.14,051.50,051.96,052.64,053.38,053.08, ...
     +051.30,048.36,044.90,041.02,037.24,034.40,034.38,037.86, ...
     +043.28,048.20,048.50,049.26,049.18,048.90,049.04,049.40, ...
     +049.86,050.64,051.28,051.08,049.40,046.46,042.98,039.02, ...
     +035.14,032.40,032.48,035.72,041.00,045.70,046.00,046.96, ...
     +046.98,046.80,046.94,047.30,047.76,048.54,049.28,049.08, ...
     +047.40,044.56,041.08,037.02,033.14,030.40,030.58,033.84, ...
     +038.72,043.20,043.50,044.62,044.80,044.80,044.94,045.20, ...
     +045.76,046.54,047.18,046.98,045.50,042.66,039.08,035.02, ...
     +031.14,028.40,028.58,031.82,036.52,040.80,041.20,042.32, ...
     +042.54,042.70,042.84,043.20,043.66,044.44,045.08,044.98, ...
     +043.50,040.76,037.08,033.04,029.04,026.40,026.68,029.82, ...
     +034.34,038.40,038.80,040.12,040.60,040.70,040.84,041.10, ...
     +041.62,042.34,042.98,042.88,041.50,038.76,035.18,031.04, ...
     +027.14,024.50,024.78,027.70,032.14,036.06,036.50,037.88, ...
     +038.50,038.68,038.84,039.10,039.56,040.34,040.88,040.82, ...
     +039.40,036.76,033.18,029.12,025.14,022.50,022.88,025.90, ...
     +029.96,033.86,034.30,035.68,036.42,036.68,036.84,037.10, ...
     +037.56,038.24,038.88,038.72,037.40,034.76,031.18,027.12, ...
     +023.14,020.60,020.98,023.90,027.88,031.66,032.10,033.58, ...
     +034.32,034.68,034.84,035.10,035.56,036.24,036.78,036.62, ...
     +035.30,032.72,029.18,025.14,021.24,018.70,019.08,021.90, ...
     +025.88,029.42,029.90,031.48,032.32,032.68,032.84,033.10, ...
     +033.56,034.22,034.68,034.42,033.20,030.72,027.28,023.22, ...
     +019.34,016.80,017.24,020.00,023.78,027.32,027.70,029.38, ...
     +030.24,030.68,030.94,031.20,031.66,032.22,032.58,032.32, ...
     +031.10,028.62,025.28,021.32,017.48,015.00,015.38,018.18, ...
     +021.80,025.22,025.70,027.28,028.24,028.78,029.04,029.30, ...
     +029.66,030.22,030.50,030.22,029.00,026.62,023.30,019.42, ...
     +015.64,013.10,013.54,016.28,019.80,023.12,023.60,025.24, ...
     +026.24,026.78,027.14,027.40,027.76,028.22,028.40,028.12, ...
     +026.80,024.52,021.30,017.52,013.78,011.30,011.74,014.48, ...
     +017.90,021.12,021.60,023.24,024.34,024.88,025.24,025.50, ...
     +025.86,026.22,026.40,025.98,024.70,022.48,019.40,015.72, ...
     +012.04,009.50,009.94,012.58,016.02,019.12,019.60,021.24, ...
     +022.34,022.98,023.34,023.70,024.00,024.30,024.40,023.88, ...
     +022.60,020.48,017.52,014.00,010.34,007.80,008.18,010.88, ...
     +014.22,017.18,017.60,019.34,020.44,021.16,021.54,021.90, ...
     +022.16,022.40,022.32,021.78,020.60,018.48,015.62,012.20, ...
     +008.68,006.00,006.44,009.18,012.42,015.28,015.80,017.44, ...
     +018.54,019.26,019.74,020.10,020.30,020.50,020.32,019.72, ...
     +018.50,016.54,013.84,010.68,007.14,004.40,004.74,007.58, ...
     +010.74,013.48,014.00,015.54,016.74,017.46,017.94,018.30, ...
     +018.50,018.58,018.32,017.72,016.50,014.64,012.24,009.18, ...
     +005.84,002.90,003.30,006.16,009.14,011.84,012.30,013.78, ...
     +014.94,015.66,016.24,016.50,016.70,016.70,016.42,005.78, ...
     +014.60,012.90,010.66,007.86,004.88,001.60,001.72,004.96, ...
     +007.84,010.24,010.70,012.14,013.24,013.96,014.44,014.80, ...
     +014.90,014.88,014.52,013.92,012.80,011.30,009.28,006.94, ...
     +004.32,001.80,001.94,004.34,006.78,008.94,009.40,010.58, ...
     +011.64,012.36,012.74,013.10,013.20,013.08,012.72,012.12, ...
     +011.10,009.86,008.30,006.50,004.60,003.10,003.16,004.50, ...
     +006.20,007.90,008.40,009.42,010.14,010.76,011.14,011.40, ...
     +011.40,011.38,011.02,010.46,009.70,008.72,007.64,006.46, ...
     +005.42,004.60,004.70,005.34,006.24,007.36,007.90,008.46, ...
     +008.92,009.28,009.54,009.70,009.70,009.68,009.42,009.06, ...
     +008.60,008.08,007.56,007.02,006.56,006.30,006.30,006.52, ...
     +006.96,007.38,008.15,008.15,008.15,008.15,008.15,008.15, ...
     +008.15,008.15,008.15,008.15,008.15,008.15,008.15,008.15, ...
     +008.15,008.15,008.15,008.15,008.15,008.15];
    CORMAG = zeros(NI,NJ);
    len1 = length(dat1)/NI;
    len2 = length(dat2)/NI;
    %len3 = length(dat3)/NI;
    k = 1;
    for j=1:len1
      for i=1:NI
        CORMAG(i,j) = dat1(k);
        k = k + 1;
      end
    end
    k = 1;
    for j=len1+1:len1+len2
      for i=1:NI
        CORMAG(i,j) = dat2(k);
        k = k + 1;
      end
    end
    k = 1;
    for j=len1+len2+1:NJ
      for i=1:NI
        CORMAG(i,j) = dat3(k);
        k = k + 1;
      end
    end
    fI = 1.0/(NI-2);
    fJ = (NJ-1)/180.0;
  end

  %     Data Input      
  rlan = rga;
  rlo = rgo;

  %     From "normal" geographic latitude 
  %     to angle from South Pole.       
  rla = rlan + 90;

  if (rlo == 360)
    rlo = 0;
  end

  %     PROXIMITY

  %     coefficients of the latitudinal points		
  LA1 = (floor(rla*fJ)+1);
  LA2 = LA1 + 1;
  if(LA2 > NJ)
    LA2=NJ;
  end

  %     coefficients of the longitudinal points		
  LO1 = (floor(rlo*fI)+1);
%corr      LO2 = LO1 + 1
  LO2 = mod(LO1,NI) + 1 ;

  %     Four points of Geomagnetic Coordinates
  gm1 = CORMAG(LO1,LA1);
  gm2 = CORMAG(LO1,LA2);
  gm3 = CORMAG(LO2,LA1);
  gm4 = CORMAG(LO2,LA2);

  %     latitudinal points		
  %      X1 = abs(rla - (floor(rla)))                        
  %      X2 = 2. - X1
  x = (rla*fJ - (floor(rla*fJ)));

  %     longitudinal points		
  %      Y1 = abs(rlo - (floor(rlo)))                        
  %      Y2 = 18. - Y1
  y =(rlo*fI - (floor(rlo*fI)));

  %     X AND Y VALUES
  %      x = X1 / (X1 + X2);
  %      y = Y1 / (Y1 + Y2);

  %     INTERPOLATION
  gmla = gm1 * (1 - x) * (1 - y) ...
       + gm2 * (1 - y) * (x) ...
       + gm3 * (y) * (1 - x) ...
       + gm4 * (x) * (y);

  %     OUTPUT OF THE PROGRAM
  %     From corrected geomagnetic latitude from North Pole
  %     to "normal"  geomagnetic latitude.       
  rgma = 90. - gmla;


end
