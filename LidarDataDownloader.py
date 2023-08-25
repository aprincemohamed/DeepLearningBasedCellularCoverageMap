import os
import requests

def download_file(url, save_path):
    try:
        response = requests.get(url, stream=True)
        response.raise_for_status()

        with open(save_path, 'wb') as file:
            for chunk in response.iter_content(chunk_size=8192):
                file.write(chunk)

        print(f"Downloaded: {url}")
    except requests.exceptions.RequestException as e:
        print(f"Error downloading {url}: {e}")

def main():
    download_urls = [
        # Add more URLs as needed
    ]
     
    StartPoint_Vert = 2945
    StartPoint_Hor = 1805
     
    for vert in range(0,115,5):
        for hor in range(0,135,5):
            filename = f"in2018_{StartPoint_Vert + vert}{StartPoint_Hor + hor}_12_ndhm.tif"
            url = f"https://lidar.digitalforestry.org/QL2_3DEP_LiDAR_IN_2017_2019_l2/tippecanoe/ndhm/{filename}"
            # filename = f"in2018_{StartPoint_Vert + vert}{StartPoint_Hor + hor}_12_dsm.tif"
            # url = f"https://lidar.digitalforestry.org/QL2_3DEP_LiDAR_IN_2017_2019_l2/tippecanoe/dsm/{filename}"
            download_urls.append(url)

    print(len(download_urls))

    # download_folder = "C:/Users/yanox/Dropbox/Research/Code/DeepLearningBasedCellularCoverageMap/Data/DSM"
    download_folder = "C:/Users/yanox/Dropbox/Research/Code/DeepLearningBasedCellularCoverageMap/Data/DHM"
    os.makedirs(download_folder, exist_ok=True)
    
    for url in download_urls:
        filename = url.split('/')[-1]
        save_path = os.path.join(download_folder, filename)
        download_file(url, save_path)

if __name__ == "__main__":
    main()