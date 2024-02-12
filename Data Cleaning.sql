

  SELECT *
  FROM PortfolioProjects..NashvilleHousing
   --WHERE PropertyAddress IS NULL

 --DATE CONVERSION


   SELECT Saledate, Saledateconverted
   FROM PortfolioProjects..NashvilleHousing

 ALTER TABLE NashvilleHousing
 ADD Saledateconverted Date

 UPDATE  NashvilleHousing
 SET Saledateconverted = CONVERT (Date,Saledate )


 --POPULATING A NULL COLUMN


  SELECT *
  FROM PortfolioProjects..NashvilleHousing
  WHERE PropertyAddress IS NULL
  ORDER BY parcelID


  SELECT  a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
  FROM PortfolioProjects..NashvilleHousing a 
  JOIN PortfolioProjects..NashvilleHousing b
  ON a.parcelID = b.parcelID
  AND a.[uniqueID] <> b.[uniqueID]
  WHERE a.PropertyAddress IS NULL
  --ORDER BY parcelID

  UPDATE a
  SET PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
    FROM PortfolioProjects..NashvilleHousing a 
  JOIN PortfolioProjects..NashvilleHousing b
  ON a.parcelID = b.parcelID
  AND a.[uniqueID] <> b.[uniqueID]
  WHERE a.PropertyAddress IS NULL
  --ORDER BY parcelID

  --SPLITING A COLUMN

   SELECT 
   SUBSTRING (PropertyAddress,1,CHARINDEX ( ',',PropertyAddress)-1) AS Address,
   SUBSTRING (PropertyAddress,CHARINDEX (',',PropertyAddress)+1, LEN(PropertyAddress)) AS Address
   FROM PortfolioProjects..NashvilleHousing

   ALTER TABLE NashvilleHousing
 ADD PropertysplitAddress VARCHAR (225);

 UPDATE  NashvilleHousing
 SET PropertysplitAddress = SUBSTRING (PropertyAddress,1,CHARINDEX ( ',',PropertyAddress)-1)

 ALTER TABLE NashvilleHousing
 ADD Propertysplitcity VARCHAR (225);

 UPDATE  NashvilleHousing
 SET Propertysplitcity = SUBSTRING (PropertyAddress,CHARINDEX (',',PropertyAddress)+1, LEN(PropertyAddress))

   SELECT *
  FROM PortfolioProjects..NashvilleHousing

     SELECT OwnerAddress
  FROM PortfolioProjects..NashvilleHousing

  SELECT 
  PARSENAME(REPLACE(OwnerAddress,',','.'),3),
   PARSENAME(REPLACE(OwnerAddress,',','.'),2),
    PARSENAME(REPLACE(OwnerAddress,',','.'),1)
	FROM PortfolioProjects..NashvilleHousing

	 ALTER TABLE NashvilleHousing
 ADD OwnersplitAddress VARCHAR (225);

	UPDATE  NashvilleHousing
 SET OwnersplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

 ALTER TABLE NashvilleHousing
 ADD Ownersplitcity VARCHAR (225);

 UPDATE  NashvilleHousing
 SET Ownersplitcity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

  ALTER TABLE NashvilleHousing
 ADD ownersplitstate VARCHAR (225);


 UPDATE  NashvilleHousing
 SET ownersplitstate = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

    SELECT *
  --FROM PortfolioProjects..NashvilleHousing 

  ---REPLACING Y AND N WITH YES AND NO


SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProjects..NashvilleHousing 
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END
FROM PortfolioProjects..NashvilleHousing 

 UPDATE  NashvilleHousing
 SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END
FROM PortfolioProjects..NashvilleHousing 

--LOOKING FOR DUPLICATES

WITH RowNumCTE AS(
SELECT *,
   ROW_NUMBER() OVER (
   PARTITION BY ParcelID,
                PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
                  UniqueID
				  )Row_num
FROM PortfolioProjects..NashvilleHousing 

--ORDER BY ParcelID
)

SELECT *
FROM RowNumCTE
WHERE Row_num > 1
ORDER BY PropertyAddress

--DELETING

WITH RowNumCTE AS(
SELECT *,
   ROW_NUMBER() OVER (
   PARTITION BY ParcelID,
                PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
                  UniqueID
				  )Row_num
FROM PortfolioProjects..NashvilleHousing 

--ORDER BY ParcelID
)


DELETE 
FROM RowNumCTE
WHERE Row_num > 1
--ORDER BY PropertyAddress




