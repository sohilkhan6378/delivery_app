const USERS_SHEET_NAME = 'Users';
const ORDERS_SHEET_NAME = 'Orders';
const DRIVE_FOLDER_ID = '';

function doGet(e) {
  const path = (e.parameter.path || '').toLowerCase();
  if (path === 'orders') {
    const assignedTo = e.parameter.assignedTo || '';
    const data = getOrders(assignedTo);
    return jsonResponse({ data });
  }
  return jsonResponse({ message: 'Not found' }, 404);
}

function doPost(e) {
  const path = (e.parameter.path || '').toLowerCase();
  const payload = JSON.parse(e.postData.contents || '{}');
  if (path === 'login') {
    return jsonResponse(login(payload.identifier));
  }
  if (path === 'pickupsubmit') {
    return jsonResponse(pickupSubmit(payload));
  }
  if (path === 'deliverysubmit') {
    return jsonResponse(deliverySubmit(payload));
  }
  return jsonResponse({ message: 'Not found' }, 404);
}

function login(identifier) {
  const sheet = SpreadsheetApp.getActive().getSheetByName(USERS_SHEET_NAME);
  const rows = sheet.getDataRange().getValues();
  const headers = rows.shift();
  const emailIndex = headers.indexOf('Email');
  const phoneIndex = headers.indexOf('Phone');
  const match = rows.find((row) => {
    return row[emailIndex] == identifier || row[phoneIndex] == identifier;
  });
  if (!match) {
    return { success: false, message: 'User not found' };
  }
  const user = {};
  headers.forEach((header, index) => {
    user[header] = match[index];
  });
  return { success: true, user };
}

function getOrders(assignedTo) {
  const sheet = SpreadsheetApp.getActive().getSheetByName(ORDERS_SHEET_NAME);
  const rows = sheet.getDataRange().getValues();
  const headers = rows.shift();
  const assignedIndex = headers.indexOf('AssignedPerson');
  return rows
    .filter((row) => row[assignedIndex] == assignedTo)
    .map((row) => {
      const order = {};
      headers.forEach((header, index) => {
        order[header] = row[index];
      });
      return order;
    });
}

function pickupSubmit(payload) {
  const sheet = SpreadsheetApp.getActive().getSheetByName(ORDERS_SHEET_NAME);
  const rows = sheet.getDataRange().getValues();
  const headers = rows.shift();
  const orderIdIndex = headers.indexOf('OrderID');
  const pickupPhotoIndex = headers.indexOf('PickupPhoto');
  const pickupTimeIndex = headers.indexOf('PickupTime');
  const pickupStatusIndex = headers.indexOf('PickupStatus');

  const rowIndex = rows.findIndex((row) => row[orderIdIndex] == payload.orderId);
  if (rowIndex === -1) {
    return { success: false, message: 'Order not found' };
  }
  const photoUrl = uploadBase64(payload.pickupPhoto, 'pickup');
  const sheetRow = rowIndex + 2;
  sheet.getRange(sheetRow, pickupPhotoIndex + 1).setValue(photoUrl);
  sheet.getRange(sheetRow, pickupTimeIndex + 1).setValue(payload.pickupTime);
  sheet.getRange(sheetRow, pickupStatusIndex + 1).setValue(payload.pickupStatus);
  return { success: true };
}

function deliverySubmit(payload) {
  const sheet = SpreadsheetApp.getActive().getSheetByName(ORDERS_SHEET_NAME);
  const rows = sheet.getDataRange().getValues();
  const headers = rows.shift();
  const orderIdIndex = headers.indexOf('OrderID');
  const deliveryPhotoIndex = headers.indexOf('DeliveryPhoto');
  const deliveryTimeIndex = headers.indexOf('DeliveryTime');
  const deliveryStatusIndex = headers.indexOf('DeliveryStatus');
  const receiverPhotoIndex = ensureColumn(sheet, headers, 'ReceiverPhoto');
  const deliveryLocationIndex = ensureColumn(sheet, headers, 'DeliveryLocation');

  const rowIndex = rows.findIndex((row) => row[orderIdIndex] == payload.orderId);
  if (rowIndex === -1) {
    return { success: false, message: 'Order not found' };
  }
  const deliveryUrl = uploadBase64(payload.deliveryPhoto, 'delivery');
  const receiverUrl = uploadBase64(payload.receiverPhoto, 'receiver');
  const sheetRow = rowIndex + 2;
  sheet.getRange(sheetRow, deliveryPhotoIndex + 1).setValue(deliveryUrl);
  sheet.getRange(sheetRow, receiverPhotoIndex + 1).setValue(receiverUrl);
  sheet.getRange(sheetRow, deliveryLocationIndex + 1).setValue(payload.deliveryLocation);
  sheet.getRange(sheetRow, deliveryTimeIndex + 1).setValue(payload.deliveryTime);
  sheet.getRange(sheetRow, deliveryStatusIndex + 1).setValue(payload.deliveryStatus);
  return { success: true };
}

function uploadBase64(base64Data, prefix) {
  const blob = Utilities.newBlob(Utilities.base64Decode(base64Data));
  const fileName = `${prefix}_${Date.now()}.jpg`;
  const folder = DRIVE_FOLDER_ID
    ? DriveApp.getFolderById(DRIVE_FOLDER_ID)
    : DriveApp.getRootFolder();
  const file = folder.createFile(blob).setName(fileName);
  file.setSharing(DriveApp.Access.ANYONE_WITH_LINK, DriveApp.Permission.VIEW);
  return file.getUrl();
}

function ensureColumn(sheet, headers, columnName) {
  const index = headers.indexOf(columnName);
  if (index !== -1) {
    return index;
  }
  const newIndex = headers.length;
  sheet.getRange(1, newIndex + 1).setValue(columnName);
  return newIndex;
}

function jsonResponse(data, status) {
  const output = ContentService.createTextOutput(JSON.stringify(data));
  output.setMimeType(ContentService.MimeType.JSON);
  if (status) {
    output.setHeader('Status', status.toString());
  }
  return output;
}
