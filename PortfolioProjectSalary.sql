SELECT *
FROM RemuneracionFixed$

-- �Cu�l es la distribuci�n de edades de los empleados en la base de datos?

CREATE TABLE #Temp_GruposEtarios(
ID int,
GruposDeEdad varchar(100)
)

INSERT INTO #Temp_GruposEtarios
SELECT ID,
CASE
	WHEN tengo_edad >= 50 THEN 'VIEJO'
	WHEN tengo_edad >= 25 THEN 'ADULTO'
	ELSE 'JOVEN'
END as GruposDeEdad
FROM RemuneracionFixed$

SELECT GruposDeEdad, COUNT(GruposDeEdad) AS Cantidad
FROM #Temp_GruposEtarios
WHERE GruposDeEdad = 'JOVEN'
GROUP BY GruposDeEdad
UNION
SELECT GruposDeEdad, COUNT(GruposDeEdad)
FROM #Temp_GruposEtarios
WHERE GruposDeEdad = 'ADULTO'
GROUP BY GruposDeEdad
UNION
SELECT GruposDeEdad, COUNT(GruposDeEdad)
FROM #Temp_GruposEtarios
WHERE GruposDeEdad = 'VIEJO'
GROUP BY GruposDeEdad

-- �Cu�l es la edad maxima, minima y promedio de los empleados?

SELECT MAX(tengo_edad) AS EdadMaxima
FROM RemuneracionFixed$

SELECT MIN(tengo_edad) AS EdadMinima
FROM RemuneracionFixed$

SELECT AVG(tengo_edad) AS EdadPromedio
FROM RemuneracionFixed$

-- �Cu�l es el salario promedio en cada rubro de trabajo?

SELECT *
FROM RemuneracionFixed$

SELECT trabajo_de, AVG(_sal) as SalarioPromedio
FROM RemuneracionFixed$
GROUP BY trabajo_de

-- �Hay alguna correlaci�n entre la edad y el salario?

SELECT *
FROM RemuneracionFixed$

SELECT *
FROM #Temp_GruposEtarios

SELECT GE.GruposDeEdad, AVG(RF._sal) EdadSalario
FROM #Temp_GruposEtarios AS GE 
JOIN RemuneracionFixed$ AS RF
	ON GE.ID = RF.ID
GROUP BY GE.GruposDeEdad

-- �Cu�l es el salario m�ximo y m�nimo en la base de datos?

SELECT MAX(_sal) AS SalarioMasAlto, MIN(_sal) AS SalarioMasBajo
FROM RemuneracionFixed$

-- �Cu�l es el salario m�ximo y m�nimo por puesto?

SELECT MAX(_sal) AS SalarioMasAlto, MIN(_sal) AS SalarioMasBajo, trabajo_de
FROM RemuneracionFixed$ 
group by trabajo_de

-- �Cu�ntos empleados tienen cada tipo de contrato?

SELECT tipo_de_contrato, COUNT(tipo_de_contrato) AS CantidadDeTipoDeContrato
FROM RemuneracionFixed$
GROUP BY tipo_de_contrato

-- �Cu�l es la distribuci�n de salarios entre los diferentes tipos de contrato?

SELECT tipo_de_contrato, AVG(_sal) AS SalarioPromedioPorTipo
FROM RemuneracionFixed$
GROUP BY tipo_de_contrato

-- �Cu�l es la proporci�n de empleados que reciben pagos en DOLARES?

SELECT pagos_en_dolares, COUNT(pagos_en_dolares) AS CuantosRecibenElSueldoEnDolares
FROM RemuneracionFixed$
WHERE pagos_en_dolares IS NOT NULL
GROUP BY pagos_en_dolares

--�Hay alguna correlaci�n entre el tipo de contrato y los pagos en criptomonedas?

SELECT tipo_de_contrato, pagos_en_dolares, COUNT(pagos_en_dolares) AS CuantosRecibenElSueldoEnDolares
FROM RemuneracionFixed$
WHERE pagos_en_dolares IS NOT NULL
GROUP BY tipo_de_contrato, pagos_en_dolares
ORDER BY CuantosRecibenElSueldoEnDolares DESC

-- �Cu�l es el nivel educativo m�s com�n entre los empleados?

SELECT *
FROM RemuneracionFixed$

SELECT maximo_nivel_de_estudios, COUNT(maximo_nivel_de_estudios) as NivelEducativoMasComun
FROM RemuneracionFixed$
WHERE maximo_nivel_de_estudios IS NOT NULL
GROUP BY maximo_nivel_de_estudios
ORDER BY NivelEducativoMasComun DESC

-- �Existe alguna relaci�n entre el nivel educativo y el salario?

SELECT maximo_nivel_de_estudios, AVG(_sal) AS SalarioPromedioEstudios
FROM RemuneracionFixed$
GROUP BY maximo_nivel_de_estudios
ORDER BY SalarioPromedioEstudios DESC

-- �Existe alguna relaci�n entre los a�os de experiencia y la modalidad de trabajo?

SELECT *
FROM RemuneracionFixed$

SELECT anos_de_experiencia, modalidad_de_trabajo
FROM RemuneracionFixed$
GROUP BY anos_de_experiencia, modalidad_de_trabajo
ORDER BY anos_de_experiencia DESC

-- �Existe alguna relaci�n entre seniority y el salario?

SELECT seniority, AVG(_sal) SalarioPromedioPorSeniority
FROM RemuneracionFixed$
GROUP BY seniority
ORDER BY SalarioPromedioPorSeniority