{*
* 2007-2013 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2007-2013 PrestaShop SA
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}

<div class="leadin">{block name="leadin"}{/block}</div>

<script type="text/javascript">
	id_language = Number({$current_id_lang});
</script>

{block name="defaultOptions"}
<form action="{$current}&token={$token}"
	id="{if $table == null}configuration_form{else}{$table}_form{/if}"
	{if isset($categoryData['name'])} name={$categoryData['name']}{/if}
	{if isset($categoryData['id'])} id={$categoryData['id']} {/if}
	method="post"
	enctype="multipart/form-data" class="form-horizontal">
	{foreach $option_list AS $category => $categoryData}
		{if isset($categoryData['top'])}{$categoryData['top']}{/if}
		<div class="panel {if isset($categoryData['class'])}{$categoryData['class']}{/if}" id="{$table}_fieldset_{$category}">
			{* Options category title *}
			<h3>
				<i class="{if isset($categoryData['icon'])}{$categoryData['icon']}{else}icon-cogs{/if}"></i>
				{if isset($categoryData['title'])}{$categoryData['title']}{else}{l s='Options'}{/if}
			</h3>

			{* Category description *}

			{if (isset($categoryData['description']) && $categoryData['description'])}
				<div class="alert alert-info">{$categoryData['description']}</div>
			{/if}
			{* Category info *}
			{if (isset($categoryData['info']) && $categoryData['info'])}
				<p>{$categoryData['info']}</p>
			{/if}

			{if !$categoryData['hide_multishop_checkbox'] && $use_multishop}
			<div class="well clearfix">
				<label class="control-label col-lg-3">
					<i class="icon-sitemap"></i> {l s='Multistore'}
				</label>
				<div class="col-lg-9">
					<div class="row">
						<div class="col-lg-6">
							<span class="switch prestashop-switch">
								<input type="radio" name="{$table}_multishop_{$category}" id="{$table}_multishop_{$category}_on" value="1" onclick="toggleAllMultishopDefaultValue($('#{$table}_fieldset_{$category}'), true)">
								<label for="{$table}_multishop_{$category}_on">
									<i class="icon-check-sign color_success"></i> {l s='Yes'}
								</label>
								<input type="radio" name="{$table}_multishop_{$category}" id="{$table}_multishop_{$category}_off" value="0" checked="checked" onclick="toggleAllMultishopDefaultValue($('#{$table}_fieldset_{$category}'), false)">
								<label for="{$table}_multishop_{$category}_off">
									<i class="icon-ban-circle color_danger"></i> {l s='No'}
								</label>
								<a class="slide-button btn btn-default"></a>
							</span>
						</div>
												<p class="help-block">
							<strong>{l s='Check / Uncheck all'}</strong>
							{l s='(Check boxes if you want to set a custom value for this shop or group shop context)'}
						</p>

					</div>
				</div>
			</div>
			{/if}

			{foreach $categoryData['fields'] AS $key => $field}
					{if $field['type'] == 'hidden'}
						<input type="hidden" name="{$key}" value="{$field['value']}" />
					{else}
						<div class="form-group">
							<div id="conf_id_{$key}" {if $field['is_invisible']} class="isInvisible"{/if}>								
								{block name="label"}
									{if isset($field['title']) && isset($field['hint'])}
										<label class="control-label col-lg-3 {if isset($field['required']) && $field['required'] && $field['type'] != 'radio'}required{/if}" for="{$key}">
											{if !$categoryData['hide_multishop_checkbox'] && $field['multishop_default'] && empty($field['no_multishop_checkbox'])}
											<input type="checkbox" name="multishopOverrideOption[{$key}]" value="1" {if !$field['is_disabled']}checked="checked"{/if} onclick="toggleMultishopDefaultValue(this, '{$key}')"/>
											{/if}
											<span title="" data-toggle="tooltip" class="label-tooltip" data-original-title="
												{if is_array($field['hint'])}
													{foreach $field['hint'] as $hint}
														{if is_array($hint)}
															{$hint.text}
														{else}
															{$hint}
														{/if}
													{/foreach}
												{else}
													{$field['hint']}
												{/if}
											" data-html="true">
												{$field['title']}
											</span>
										</label>
									{elseif isset($field['title'])}
										<label class="control-label col-lg-3" for="{$key}">
											{if !$categoryData['hide_multishop_checkbox'] && $field['multishop_default'] && empty($field['no_multishop_checkbox'])}
											<input type="checkbox" name="multishopOverrideOption[{$key}]" value="1" {if !$field['is_disabled']}checked="checked"{/if} onclick="checkMultishopDefaultValue(this, '{$key}')" />
											{/if}
											{$field['title']}
										</label>
									{/if}									
								{/block}
								{block name="field"}

								{block name="input"}
									{if $field['type'] == 'select'}
										<div class="col-lg-9">
											{if $field['list']}
												<select name="{$key}"{if isset($field['js'])} onchange="{$field['js']}"{/if} id="{$key}" {if isset($field['size'])} size="{$field['size']}"{/if}>
													{foreach $field['list'] AS $k => $option}
														<option value="{$option[$field['identifier']]}"{if $field['value'] == $option[$field['identifier']]} selected="selected"{/if}>{$option['name']}</option>
													{/foreach}
												</select>
											{else if isset($input.empty_message)}
												{$input.empty_message}
											{/if}
										</div>
									{elseif $field['type'] == 'bool'}
										<div class="col-lg-9">
											<div class="row">
												<div class="input-group col-lg-2">
													<span class="switch prestashop-switch">
														<input type="radio" name="{$key}" id="{$key}_on" value="1" {if $field['value']} checked="checked"{/if}{if isset($field['js']['on'])} {$field['js']['on']}{/if}/>
														<label for="{$key}_on" class="radioCheck">
															<i class="icon-check-sign color_success"></i> {l s='Yes'}
														</label>
														<input type="radio" name="{$key}" id="{$key}_off" value="0" {if !$field['value']} checked="checked"{/if}{if isset($field['js']['off'])} {$field['js']['off']}{/if}/>
														<label for="{$key}_off" class="radioCheck">
															<i class="icon-ban-circle color_danger"></i> {l s='No'}
														</label>
														<a class="slide-button btn btn-default"></a>
													</span>
												</div>
											</div>
										</div>

									{elseif $field['type'] == 'radio'}
										<div class="col-lg-9">
											{foreach $field['choices'] AS $k => $v}

												<p class="radio">
													<label for="{$key}_{$k}">
														<input type="radio" name="{$key}" id="{$key}_{$k}" value="{$k}"{if $k == $field['value']} checked="checked"{/if}{if isset($field['js'][$k])} {$field['js'][$k]}{/if}/>
													 	{$v}
													</label>
												</p>
											{/foreach}
										</div>
									{elseif $field['type'] == 'checkbox'}

										<div class="col-lg-9">
											{foreach $field['choices'] AS $k => $v}

												<p class="checkbox">
													<input type="checkbox" name="{$key}" id="{$key}{$k}_on" value="{$k|intval}"{if $k == $field['value']} checked="checked"{/if}{if isset($field['js'][$k])} {$field['js'][$k]}{/if}/>
													<label class="col-lg-3" for="{$key}{$k}_on"> {$v}</label>
												</p>
											{/foreach}
										</div>
									{elseif $field['type'] == 'text'}
										<div class="col-lg-9 {if isset($field['suffix'])}input-group{/if}">
											<input type="{$field['type']}"{if isset($field['id'])} id="{$field['id']}"{/if} size="{if isset($field['size'])}{$field['size']|intval}{else}5{/if}" name="{$key}" value="{$field['value']|escape:'html':'UTF-8'}" {if isset($field['autocomplete']) && !$field['autocomplete']}autocomplete="off"{/if}/>
											{if isset($field['suffix'])}
											<span class="input-group-addon">
												{$field['suffix']|strval}
											</span>
											{/if}
										</div>
									{elseif $field['type'] == 'password'}
										<div class="col-lg-9 {if isset($field['suffix'])}input-group{/if}">
											<input type="{$field['type']}"{if isset($field['id'])} id="{$field['id']}"{/if} size="{if isset($field['size'])}{$field['size']|intval}{else}5{/if}" name="{$key}" value="" {if isset($field['autocomplete']) && !$field['autocomplete']}autocomplete="off"{/if} />
											{if isset($field['suffix'])}
											<span class="input-group-addon">
												{$field['suffix']|strval}
											</span>
											{/if}
										</div>
									{elseif $field['type'] == 'textarea'}
										<div class="col-lg-9">
											<textarea class="textarea-autosize" name={$key} cols="{$field['cols']}" rows="{$field['rows']}">{$field['value']|escape:'html':'UTF-8'}</textarea>
										</div>
									{elseif $field['type'] == 'file'}
										<div class="col-lg-9">{$field['file']}</div>
						            {elseif $field['type'] == 'color'}
										<div class="col-lg-2">
											<div class="row">
												<div class="input-group">
									              <input type="color" size="{$field['size']}" data-hex="true" {if isset($input.class)}class="{$field['class']}" {else}class="color mColorPickerInput"{/if} name="{$field['name']}" class="{if isset($field['class'])}{$field['class']}{/if}" value="{$field['value']|escape:'html':'UTF-8'}" />
									            </div>
									        </div>
							            </div>
									{elseif $field['type'] == 'price'}
										<div class="input-group col-lg-9">
											<span class="input-group-addon">{$currency_left_sign}{$currency_right_sign} {l s='(tax excl.)'}</span>
											<input type="text" size="{if isset($field['size'])}{$field['size']|intval}{else}5{/if}" name="{$key}" value="{$field['value']|escape:'html':'UTF-8'}" />
										</div>
									{elseif $field['type'] == 'textLang' || $field['type'] == 'textareaLang' || $field['type'] == 'selectLang'}

										{if $field['type'] == 'textLang'}
											<div class="col-lg-9">
												<div class="row">
												{foreach $field['languages'] AS $id_lang => $value}
													{if $field['languages']|count > 1}
													<div class="translatable-field lang-{$id_lang}" {if $id_lang != $current_id_lang}style="display:none;"{/if}>
														<div class="col-lg-9">
													{else}
													<div class="col-lg-12">
													{/if}
															<input type="text"
																name="{$key}_{$id_lang}"
																value="{$value|escape:'html':'UTF-8'}"
																{if isset($input.class)}class="{$input.class}"{/if}
															/>
													{if $field['languages']|count > 1}
														</div>
														<div class="col-lg-2">
															<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
																{foreach $languages as $language}
																	{if $language.id_lang == $id_lang}{$language.iso_code}{/if}
																{/foreach}
																<span class="caret"></span>
															</button>
															<ul class="dropdown-menu">
																{foreach $languages as $language}
																<li>
																	<a href="javascript:hideOtherLanguage({$language.id_lang});">{$language.name}</a>
																</li>
																{/foreach}
															</ul>
														</div>
													</div>
													{else}
													</div>
													{/if}
												{/foreach}
												</div>
											</div>

										{elseif $field['type'] == 'textareaLang'}
											<div class="col-lg-9">
												{foreach $field['languages'] AS $id_lang => $value}
													<div class="row translatable-field lang-{$id_lang}" {if $id_lang != $current_id_lang}style="display:none;"{/if}>
														<div id="{$key}_{$id_lang}" class="col-lg-9" >
															<textarea class="textarea-autosize" name="{$key}_{$id_lang}">{$value|replace:'\r\n':"\n"}</textarea>
														</div>
														<div class="col-lg-2">
															<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
																{foreach $languages as $language}
																	{if $language.id_lang == $id_lang}{$language.iso_code}{/if}
																{/foreach}
																<span class="caret"></span>
															</button>
															<ul class="dropdown-menu">
																{foreach $languages as $language}
																<li>
																	<a href="javascript:hideOtherLanguage({$language.id_lang});">{$language.name}</a>
																</li>
																{/foreach}
															</ul>
														</div>

													</div>
												{/foreach}
												<script type="text/javascript">
													$(document).ready(function() {
														$(".textarea-autosize").autosize();
													});
												</script>
											</div>

										{elseif $field['type'] == 'selectLang'}
											{foreach $languages as $language}

												<div id="{$key}_{$language.id_lang}" style="display: {if $language.id_lang == $current_id_lang}block{else}none{/if};" class="col-lg-9">
													<select name="{$key}_{$language.iso_code|upper}">
														{foreach $field['list'] AS $k => $v}
															<option value="{if isset($v.cast)}{$v.cast[$v[$field.identifier]]}{else}{$v[$field.identifier]}{/if}"
																{if $field['value'][$language.id_lang] == $v['name']} selected="selected"{/if}>
																{$v['name']}
															</option>
														{/foreach}
													</select>
												</div>
											{/foreach}
										{/if}

<!--
{if count($languages) > 1}
	<div class="displayed_flag">
		<img src="../img/l/{$current_id_lang}.jpg" class="pointer" id="language_current_{$key}" onclick="toggleLanguageFlags(this);" />
	</div>
	<div id="languages_{$key}" class="language_flags">

		{l s='Choose language:'}

		{foreach $languages as $language}
				<img src="../img/l/{$language.id_lang}.jpg" class="pointer" alt="{$language.name}" title="{$language.name}" onclick="changeLanguage('{$key}', '{if isset($custom_key)}{$custom_key}{else}{$key}{/if}', {$language.id_lang}, '{$language.iso_code}');" />
		{/foreach}
	</div>
{/if}
-->

									{/if}

									{if isset($field['desc']) && !empty($field['desc'])}
									<div class="col-lg-9 col-lg-push-3">
										<p class="help-block">
											{if is_array($field['desc'])}
												{foreach $field['desc'] as $p}
													{if is_array($p)}
														<span id="{$p.id}">{$p.text}</span><br />
													{else}
														{$p}<br />
													{/if}
												{/foreach}
											{else}
												{$field['desc']}
											{/if}
										</p>
									</div>
									{/if}
								{/block}{* end block input *}
								{if $field['is_invisible']}
								<div class="col-lg-9 col-lg-push-3">
									<p class="alert alert-warning">
										{l s='You can\'t change the value of this configuration field in the context of this shop.'}
									</p>
								</div>
								{/if}
								{/block}{* end block field *}
							</div>
						</div>
				{/if}
			{/foreach}
			{if isset($categoryData['submit'])}
				<div class="form-group">
					<div class="col-lg-9 col-lg-offset-3">
						<button
							type="submit"
							id="{$table}_form_submit_btn"
							name="{if isset($categoryData['submit']['name'])}{$categoryData['submit']['name']}{else}submitOptions{$table}{/if}"
							class="{if isset($categoryData['submit']['class'])}{$categoryData['submit']['class']}{else}btn btn-default{/if}"
							>
							{if isset($categoryData['submit']['title'])}{$categoryData['submit']['title']}{else}{l s='Save'}{/if}
						</button>
					</div>
				</div>
			{/if}
<!-- 			{*if isset($categoryData['required_fields']) && $categoryData['required_fields']}
				<div class="small"><sup>*</sup> {l s='Required field'}</div>
			{/if*} -->
			{if isset($categoryData['bottom'])}{$categoryData['bottom']}{/if}
			{block name="footer"}
			{include file="footer_toolbar.tpl"}
			{/block}
		</div>
	{/foreach}
	{hook h='displayAdminOptions'}
	{if isset($name_controller)}
		{capture name=hookName assign=hookName}display{$name_controller|ucfirst}Options{/capture}
		{hook h=$hookName}
	{elseif isset($smarty.get.controller)}
		{capture name=hookName assign=hookName}display{$smarty.get.controller|ucfirst|htmlentities}Options{/capture}
		{hook h=$hookName}
	{/if}
</form>
{/block}
{block name="after"}{/block}
