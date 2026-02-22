@regression
Feature: Automatizar el backend de PetStore

  Background:
    * url baseUrl
    * header Content-Type = 'application/json'
    * def jsonCrearMascota = read('classpath:examples/jsondata/crearMascota.json')

  @TEST-1 @CreacionMascota
  Scenario: Crear una nueva mascota en PetStore y verificar su creación

    Given path 'pet'
    And request jsonCrearMascota
    When method post
    Then status 200
    And match response.id == 8193
    And  match response.name == 'doggie'
    And match response.status == 'available'
    * def petId = response.id
    And print petId
    Given path 'pet', petId
    When method get
    Then status 200
    And match response.name == jsonCrearMascota.name
    And match response.status == jsonCrearMascota.status


  @TEST-2
  Scenario: Buscar mascotas por status available

    Given path 'pet', 'findByStatus'
    And param status = 'available'
    When method get
    Then status 200
    And match each response[*].status == 'available'


  @TEST-3
  Scenario: Buscar mascotas por status pending

    Given path 'pet', 'findByStatus'
    And param status = 'pending'
    When method get
    Then status 200
    And match each response[*].status == 'pending'


  @TEST-4
  Scenario: Buscar mascotas por status sold

    Given path 'pet', 'findByStatus'
    And param status = 'sold'
    When method get
    Then status 200
    And match each response[*].status == 'sold'


  @TEST-5
  Scenario: Obtener mascota por ID

    Given path 'pet'
    And request jsonCrearMascota
    When method post
    Then status 200
    * def petId = response.id

    Given path 'pet', petId
    When method get
    Then status 200
    And match response.id == petId

  @TEST-6
  Scenario: Actualizar una mascota existente

    * set jsonCrearMascota.id = 8193
    * set jsonCrearMascota.name = 'yolo'
    * set jsonCrearMascota.status = 'sold'

    Given path 'pet'
    And request jsonCrearMascota
    When method put
    Then status 200
    And match response.status == 'sold'
    And match response.name == 'yolo'


  @TEST-7
  Scenario: Eliminar mascota por ID

    Given path 'pet', 8193
    And header api_key = 'special-key'
    When method delete
    Then status 200


  @TEST-8
  Scenario: Subir imagen a una mascota

    Given path 'pet', 8193, 'uploadImage'
    And param additionalMetadata = 'foto de prueba'
    And multipart file file = { read: 'classpath:examples/users/perro.jpg', filename: 'perro.jpg', contentType: 'image/jpeg' }
    When method post
    Then status 200
    And match response.code == 200


  @TEST-9
  Scenario: Obtener mascota por ID

    * def jsonCrearMascota = read('classpath:examples/jsondata/crearMascota.json')

    Given path 'pet'
    And request jsonCrearMascota
    When method post
    Then status 200
    * def petId = response.id

    Given path 'pet', petId
    When method get
    Then status 200
    And print response
    And match response.id == petId