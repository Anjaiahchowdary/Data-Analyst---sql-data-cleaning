Select *
From [protfoilo project].dbo.NashvilleHousing

----standarize Date format

select SaleDateConverted, convert(Date,SaleDate)
from [protfoilo project].dbo.NashvilleHousing


Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

--- populate property address data

select *
from [protfoilo project].dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from [protfoilo project].dbo.NashvilleHousing a
join [protfoilo project].dbo.NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 And a.[UniqueID ] <> b.[UniqueID ]
	 where a.PropertyAddress is null
	 
update a
SET PropertyAddress = isNull(a.PropertyAddress,b.PropertyAddress)
from [protfoilo project].dbo.NashvilleHousing a
join [protfoilo project].dbo.NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 And a.[UniqueID ] <> b.[UniqueID ]
	 where a.PropertyAddress is null




--- breaking out Address into Individual columns (Address, city, state)

select propertyADdress
from [protfoilo project].dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From [protfoilo project].dbo.NashvilleHousing a


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From [protfoilo project].dbo.NashvilleHousing a





Select OwnerAddress
From [protfoilo project].dbo.NashvilleHousing a


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [protfoilo project].dbo.NashvilleHousing a



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From [protfoilo project].dbo.NashvilleHousing a




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [protfoilo project].dbo.NashvilleHousing a
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [protfoilo project].dbo.NashvilleHousing a


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [protfoilo project].dbo.NashvilleHousing a
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From [protfoilo project].dbo.NashvilleHousing a




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From [protfoilo project].dbo.NashvilleHousing a


ALTER TABLE [protfoilo project].dbo.NashvilleHousing ag
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

ALTER TABLE [protfoilo project].dbo.NashvilleHousing ag
DROP COLUMN SaleDate













