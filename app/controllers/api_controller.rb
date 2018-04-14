require 'json'
require 'net/http'
require 'uri'
require 'browser'

class ApiController < ApplicationController
    include HTTParty

    def browser
        user_agent = request.user_agent
        browser = Browser.new(user_agent)

        tablet = browser.device.tablet? ? 'tablet' : nil
        mobile = browser.device.mobile? ? 'phone' : nil
        desktop = (!browser.device.tablet? && !browser.device.mobile?) ? 'desktop' : nil
        platform = tablet || mobile || desktop
        render json: {
            tablet: tablet,
            mobile: mobile,
            desktop: desktop,
            platform: tablet || mobile || desktop
        }
    end

    def client
        zen_features = '{"no_amp_links":true,"forced_bulk_stats":false,"blurred_preview":true,"big_card_images":true,"complaints_with_reasons":true,"pass_experiments":false,"video_providers":["yandex-web","youtube","youtube-web"],"screen":{"dpi":241},"need_background_image":true,"color_theme":"white","no_small_auth":true,"need_main_color":true,"need_zen_one_data":true,"screens":["feed"],"native_onboarding":true}'
        request_payload = {"stats":[{"event":"show","data":"feed#8757468177507120461#https://www.livemaster.ru/topic/2806509-ne-vybrasyvajte-starye-veschi#106608938.719857.1523540063846.91901#recc#site_desktop#0#ab:aa_forever:exp,ab:turn_off_exturnal_domain_boost:control,long_click_60_formula_0316_0318,default,ab:grid_formula:control,ab:rezen_more_button_color:black,narrative_formula_v8_simple_10k,ab:rezen_rum:control,ab:rezen_rel_noopener:use_noopener,ab:new_blender_heuristic:new_blender_for_sitedesktop,ab:narrative_desktop:narrative_desktop,ab:media_partner_program_control:control,ab:narrative_haters_ab:control,default,super_fresh_documents_boost,default,ab:morderation_bids_mew:morderation_bids_0_3,ab:rezen_new_service_cards:enable,ab:tns_pixels:enable,ab:ru_semantic_duplicates_new_similar:ru_semantic_duplicates_0_5,ab:whitener-max-nonabsolute-ban-time:control,default,ru_semantic_duplicates_new_0_7,dynamic_bids,ab:video_sitedesktop:default##url####6549580043516886369#domain#layout###plain##feed#CPPQ7dUF#","ts":1523540066224}],"bulk_ts":1523540066235}
        url = 'https://zen.yandex.ru/api/v3/launcher/more?clid=300&country_code=ru&token='

        request = HTTParty.post('https://zen.yandex.ru/api/v3/launcher/more?clid=300&country_code=ru&token=', {
            :headers => {
                'Cookie' => 'yandexuid=2483660101523639600; _ym_uid=1523639601879726055; mda=0; i=3i05rUDTh8009hmmOO1o2+5nrhEGaa8v06xQb13ndafmrptoL62yoUelQmpDDgmvHiJ3yaGVs7H3DdE81AXqs+nFTiM=; _ym_isad=2',
                'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36',
                'Accept-Encoding' => 'gzip, deflate, br',
                'Zen-Features' => zen_features
            },
            :body => request_payload.to_json
        })
        response.set_header("Content-Type", 'application/json; charset=utf-8')
        response.set_header("Content-Encoding", 'gzip')

        render json: request.body
    end
end