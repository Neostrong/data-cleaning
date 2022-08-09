--data cleaning with sql

--1
select * from Nashvillehousing

--standardize date
select convert (date, saledate) from Nashvillehousing

alter table nashvillehousing
add salesdateconverted date;

update Nashvillehousing
set salesdateconverted = convert (date, saledate)

--2
--populate property address by using selfjoin 
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull (a.propertyaddress, b.propertyaddress)
from Nashvillehousing a 
join  Nashvillehousing b 
on a.ParcelID =b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 

update a
set PropertyAddress =  isnull (a.propertyaddress, b.propertyaddress)
from Nashvillehousing a 
join  Nashvillehousing b 
on a.ParcelID =b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 

--3
--breaking address into individual columns
select propertyaddress from Nashvillehousing

select substring (propertyaddress, 0, charindex(',' ,propertyaddress))
as address, 
substring (propertyaddress, charindex(',' ,propertyaddress)+1, charindex(',' ,propertyaddress)+3)
as address from Nashvillehousing

--next is to add two new columns and its information
alter table nashvillehousing
add propertysplitaddress nvarchar(255);

update Nashvillehousing
set PropertysplitAddress = substring (propertyaddress, 0, charindex(',' ,propertyaddress))

alter table nashvillehousing
add propertysplitcity nvarchar(255);

update Nashvillehousing
set propertysplitcity = substring (propertyaddress, charindex(',' ,propertyaddress)+1, charindex(',' ,propertyaddress)+3)
select * from Nashvillehousing

--4
--address seperation by using parsename instead of substring bcos it is easier
select owneraddress from Nashvillehousing
select
PARSENAME(replace(owneraddress, ',', '.' ), 3),
PARSENAME(replace(owneraddress, ',', '.' ), 2),
PARSENAME(replace(owneraddress, ',', '.' ), 1) from Nashvillehousing

--address
 alter table nashvillehousing
add ownersplitaddress nvarchar(255);

update Nashvillehousing
set ownersplitaddress = PARSENAME(replace(owneraddress, ',', '.' ), 3)

--city
alter table nashvillehousing
add ownersplitcity nvarchar(255);

update Nashvillehousing
set ownersplitcity = PARSENAME(replace(owneraddress, ',', '.' ), 2)

--state
alter table nashvillehousing
add ownersplitstate nvarchar(255);

update Nashvillehousing
set ownersplitstate = PARSENAME(replace(owneraddress, ',', '.' ), 1)

--5
--changing Y and N to yes and no in "sold as vacant" column
select distinct(soldasvacant), count(SoldAsVacant) from Nashvillehousing group by soldasvacant
select soldasvacant,
case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant 
	end
from Nashvillehousing

update Nashvillehousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant 
	end

