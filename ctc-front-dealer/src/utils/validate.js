/**
 * Created by wenhan on 16/11/18.
 */

/**
 * @param {string} path
 * @returns {Boolean}
 */
export function isExternal(path) {
  return /^(https?:|mailto:|tel:)/.test(path)
}

/**
 * @param {string} str
 * @returns {Boolean}
 */
export function validUsername(str) {
  const valid_map = ['admin', 'editor']
  return valid_map.indexOf(str.trim()) >= 0
}
/**
 * 
 * @param {}} rule 
 * @param {*} value 
 * @param {*} callback 
 * 数字验证
 */
export function valiNumberPass(rule, value, callback){//包含小数的数字
  let reg = /^[+-]?(0|([1-9]\d*))(\.\d+)?$/g;
  if (value === '') {
      callback(new Error('请输入内容'));
  } else if (!reg.test(value)) {
      callback(new Error('请输入数字'));
  } else {
      callback();
  }
};
/**
 * 
 * @param {*} rule 
 * @param {*} value 
 * @param {*} callback 
 * 正整数
 */
export function valiPositiveNumber(rule, value, callback){//包含小数的数字
  if(Number.isInteger(Number(value)) && Number(value) > 0){                
    callback();
  }else{                 
    callback(new Error("请输入有效数字"));               
  }             
};
